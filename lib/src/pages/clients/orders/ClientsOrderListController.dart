
import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/address_provider.dart';
import 'package:villachicken/src/providers/carta_provider.dart';
import 'package:villachicken/src/traits/functions.dart';
import 'package:villachicken/src/utils/functions.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';

import 'package:villachicken/src/utils/shared_pref.dart';
class ClientsOrderListController{
 late BuildContext context;
 late Function refresh;
 
 int counter=1;
 double subotal=0;
 double Price=0.00;
 double descuento=0;
 SharedPref _sharedPref=new SharedPref();
 List selectedProducts=[];
 List carrito_sesion=[];
 bool enabled = true;
CartaProvider cartaProvider=new CartaProvider();
 List sugestive=[];
 List free=[];
 final ScrollController controller = ScrollController();
 GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();
 double recargo_delivery=Environment.recargo;
 AddressProvider addressprovider=new AddressProvider();
 List address=[];
Future init(BuildContext context,Function refresh) async{
  this.context=context;
   this.refresh=refresh;

   if(await _sharedPref.contains('order')){
      carrito_sesion=await _sharedPref.read('order');
      //print(carrito_sesion.length);
      
      

      
   }
   
  
   initCartaProvider().then((value) => {
                RequestSujestive().then((value) => {RequestFree()})
   });
    initAddressProvider();
    SetRecargoDeliveryProvider();
    CalcularPrecio();
  //setTimeout(()=>{enabled=false,refresh()},1000);
  refresh();
  
}
Future initAddressProvider() async{
    try {
          await addressprovider.init(context,  await _sharedPref.read('user') ?? {});
    } catch (e) {
      
    }
}
Future SetRecargoDeliveryProvider() async{
    if(await _sharedPref.contains('address_select')){
      try{
        address.add(await _sharedPref.read('address_select') );
       // print("*****************************RECARGO DELIVERY TYIPO DELIVERY ****************");
        if(int.parse(address[0]["ADD_TYPE"])==0){
          
          // solo delivery
          final res=await addressprovider.validate_cobertura(address[0]['ADD_LATITUD'].toString(),address[0]['ADD_LONGITUD'].toString());
          if(res['success']==true){
                //recargo_delivery=num.parse(res['recargo'].toString()).t
                //oDouble();
                //print("merchant id : ${res['merchantid']}");
                Map<String,dynamic> data ={
                                    'address':address[0]['ADD_DIR_DOMICILIO'],
                                    'lat':address[0]['ADD_LATITUD'],
                                    'lng':address[0]['ADD_LONGITUD'],
                                    'merchant_id':res['merchantid'],
                                    'idtienda':res['idtienda'],
                                    'recargo':recargo_delivery,
                                    
                                    };
              refresh();
              _sharedPref.save('cobertura', data);
              CalcularPrecio();
          }
        }else{

           recargo_delivery=0;
           // llevar setear cobertura mecharnt id
                Map<String,dynamic> data ={
                                    'address':address[0]['ADD_DIR_DOMICILIO'],
                                    'lat':address[0]['ADD_LATITUD'],
                                    'lng':address[0]['ADD_LONGITUD'],
                                    'merchant_id':address[0]['ADD_MERCHANT_ID'],
                                    'idtienda':address[0]['ADD_TIENDA_ID'],
                                    'recargo':recargo_delivery,
                                    
                                    };
           _sharedPref.save('cobertura', data);


           CalcularPrecio();
        }

      }catch(e){
        print(e);
        // Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
      }
  }

}
Future initCartaProvider() async{
  try {await cartaProvider.init(context,  User.fromJson(await _sharedPref.read('user') ?? {}));
  } catch (e) { print(e);
  }
}
Future RequestSujestive() async{
  try 
  {     
         await cartaProvider.sugestive().then((value) => { 
           sugestive=value,print("carta sujestive")
           
         });
         
  } catch (e) {
         //Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}
Future RequestFree() async{
  try 
  {     
         await cartaProvider.free().then((value) => { 
        
           free=value,addFreeToCarrito()
           ,setTimeout(()=>{enabled=false,refresh()},1000)
         });
         
  } catch (e) {
         //Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}

void addFreeToCarrito() async{

  if (free.length>0){
    refresh_carrito_free();
    free.forEach((element) {
        List Paquete_select=[];
        String NombreCombinacion="";
        int count=0;
        for (var i = 0; i < element["relationships"]["detalles"].length; i++) {
           for (var j = 0; j <element["relationships"]["detalles"][i]["relationships"]["combinaciones"].length ; j++) {
                if(element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"]=="1"){
                  if(count==0){
                    NombreCombinacion+=element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto"];
                  }else{
                    NombreCombinacion+="+"+element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto"];
                  }       
                  final it={
                            "det_id":element["relationships"]["detalles"][i]["id"],
                            "comb_id":element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["id"],
                            "prod_id":element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto_id"],
                            //"precio":element["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["porecio_adicional"]
                            "precio":0
                          };
                      
                  Paquete_select.add(it); 
                   count++;
                }
           }
        }
        final myJson = {
          "id": element["id"],
          "cantidad": 1,
          "producto":element["attributes"]["title"],
          "imagen":element["attributes"]["imagen"],
          //"pu":element["attributes"]["precion_base"],
          //"precio":element["attributes"]["precion_base"],
          "pu":element["attributes"]["precion_tienda"],
          "precio":element["attributes"]["precion_tienda"],
          "combinacion":NombreCombinacion,
          "paq_detalle":Paquete_select,
          "observacion":"",
          "numero_bolsas":0,
          "isfree":1,
          "pu_tienda":element["attributes"]["precion_tienda"],
          "precio_tienda":element["attributes"]["precion_tienda"],
          "descuento":element["attributes"]["descuento"],
          "descuento_base":element["attributes"]["descuento"],
          "descuento_percent":element["attributes"]["descuento_percent"],

        };
       if(validate_free(element["id"])){
           carrito_sesion.add(myJson);
       }
        
    });
    
    _sharedPref.save('order', carrito_sesion);
      CalcularPrecio();
  
   // calculate_dcto();
    carrito_sesion.sort((a, b) => a["isfree"].compareTo(b["isfree"]));
  }
}
  calculate_dcto(){
    if(carrito_sesion.length>0){
      carrito_sesion.forEach((element) {
        print(element['descuento']);
      });
    }
  }
  validate_free(int index){
  bool flag=true;
  if (carrito_sesion.length > 0) {
    carrito_sesion.forEach((element) {
        if(element["isfree"]==1){
            if(element["id"]==index){
              flag=false;
            }
        }
    });
  }
  return flag;

}
 refresh_carrito_free(){

  if(carrito_sesion.length>0){
    for (var i = 0; i < carrito_sesion.length; i++) {
      if(carrito_sesion[i]["isfree"]==1){
              carrito_sesion.remove(carrito_sesion[i]);
      }
        
    }

  }
}

void sum_cantidad(indicador) async{
  int cant=carrito_sesion[indicador]["cantidad"];
  cant++;
  double nuevoprecio=num.parse(carrito_sesion[indicador]["pu"]).toDouble()*cant;
  carrito_sesion[indicador]["cantidad"]=cant;
  carrito_sesion[indicador]["precio"]=nuevoprecio.toStringAsFixed(2);
  carrito_sesion[indicador]["descuento"]=num.parse(carrito_sesion[indicador]["descuento_base"].toString()).toDouble()*cant;
  //print(carrito_sesion);
  //print(carrito_sesion[indicador]["cantidad"]);
   _sharedPref.save('order',this.carrito_sesion);
  //this.cantidad++;
  //calcular_nombre_combinacion();
  CalcularPrecio();
  // refresh();
}
void rest_cantidad(indicador) async{
  int cant=carrito_sesion[indicador]["cantidad"];
  if(cant>1){
   cant--;
  double nuevoprecio=num.parse(carrito_sesion[indicador]["pu"]).toDouble()*cant;
  carrito_sesion[indicador]["cantidad"]=cant;
  carrito_sesion[indicador]["precio"]=nuevoprecio.toStringAsFixed(2);
  carrito_sesion[indicador]["descuento"]=num.parse(carrito_sesion[indicador]["descuento_base"].toString()).toDouble()*cant;
  //print(carrito_sesion);
  //print(carrito_sesion[indicador]["cantidad"]);
   _sharedPref.save('order',this.carrito_sesion);
  //this.cantidad++;
  //calcular_nombre_combinacion();
  CalcularPrecio();

  }
  

}
 void deletedItem(indicador) async{
   carrito_sesion.remove(indicador);
     _sharedPref.save('order',this.carrito_sesion);
     CalcularPrecio();
   //getTotal();
 }
/*void rest_cantidad(indicador){
  if(this.cantidad>1){
     this.cantidad--;
     calcular_nombre_combinacion();
     refresh();
  }

}
*/

void CalcularPrecio(){
    this.Price=0;
  if(carrito_sesion.length>0){
    for (var i = 0; i < this.carrito_sesion.length; i++) {
        this.Price+=num.parse(carrito_sesion[i]["pu"]).toDouble()*num.parse(carrito_sesion[i]["cantidad"].toString()).toInt();
       // print(num.parse(carrito_sesion[i]["cantidad"].toString()).toInt());
       // print(double.parse(this.carrito_sesion[i]["precio"]));
        carrito_sesion[i]["descuento"]=num.parse(carrito_sesion[i]["descuento_base"].toString()).toDouble()*num.parse(carrito_sesion[i]["cantidad"].toString()).toInt();
    }
    _sharedPref.save('order',carrito_sesion);
  }


    //this.Price=double.parse(this.Price.toStringAsFixed(2));
     FunctionsUtil fn=new FunctionsUtil(recargo_delivery);
    this.descuento=fn.getDcto(carrito_sesion);
    this.subotal=fn.getSubTotal(carrito_sesion);
    this.Price=fn.getTotal(carrito_sesion);
    
    refresh();
}

  void openDrawer(){
     key.currentState?.openDrawer();
     print("abierto");
  }
  void GoToPaqueteDetail(index) async{

    Navigator.of(context).pushNamed("client/product_details",arguments:{'id':sugestive[index]["attributes"]["paq_tienda_id"].toString()});
  }

void goToCheckout(){
   if(Price<=Environment.limit){
    mySnackbar.show(context,"El monto mínimo de compra es S/ ${Environment.limit}");
    return;
   }
   Navigator.of(context).pushNamed("client/checkout");
}


}