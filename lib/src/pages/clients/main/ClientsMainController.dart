import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/clients/main/address/ClientsMainAddressListPage.dart';
import 'package:villachicken/src/pages/clients/products/details/ClientsProductsDetailsPage.dart';
import 'package:villachicken/src/providers/carta_provider.dart';
import 'package:villachicken/src/providers/slider_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
//import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
class ClientsMainController{
late Function refresh;
late BuildContext context;

UserProvider userprovider=new UserProvider();
SliderProvider sliderprovider=new SliderProvider(); 
CartaProvider cartaProvider=new CartaProvider();
SharedPref _sharedPref=new SharedPref();
GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();
List slider=[];
//late Map<String, dynamic> slider;
late Map<String, dynamic> carta;
//List<String> promociones = new List();
//Map<String, dynamic> promociones2;
List ok=[];
List promociones=[];
List descuentos=[];
List address=[];
int selectFamily=0;
final ScrollController controller = ScrollController();
bool enabled = true;
List carrito_sesion=[];
String carrito_length="";
var user_type;
Future init(BuildContext context,Function refresh) async{
  this.context=context;
 
  print("main controller");
  /*try {
       slider=new Map<String, dynamic>.from(await sliderprovider.list());

  } catch (e) {
      print("error slidet");
  }
  */
  try {
    user_type=await _sharedPref.read('user-type');
  } catch (e) {
    
  }
  try {
       await cartaProvider.init(context,  await _sharedPref.read('user') ?? {});
      

  } catch (e) {
      print("error carta provider");
  }

  try {
    
       await sliderprovider.init(context,  await _sharedPref.read('user') ?? {});

  } catch (e) {
      print("error slider provider");
  }

    try {
       // slider=new  Map<String, dynamic>.from(await sliderprovider.list());
         /*slider=[
          {'attributes':{'image_sm':'http://192.168.1.12/api/img/sliders/Slider-02-43444.jpg'}},
           {'attributes':{'image_sm':'http://192.168.1.12/api/img/sliders/Slider-02-43444.jpg'}},
            {'attributes':{'image_sm':'http://192.168.1.12/api/img/sliders/Slider-02-43444.jpg'}}
         ];
         */
         final data=await sliderprovider.list();
         slider=data["data"];
         print('slider***********************');
         print(data);
       // slider=await sliderprovider.list();
       print(slider[0]["attributes"]);

  } catch (e) {
      print("error slider api request");
  }

  try {
      
        // ok=await cartaProvider.ListPromociones();
        ok=await cartaProvider.listar();
          for (var i = 0; i <  ok.length; i++) {
            for (var j = 0; j < ok[i]["relationships"]["paquetes"].length; j++) {
                if( double.parse(ok[i]["relationships"]["paquetes"][j]["attributes"]["descuento"])>0){
                  //print(ok[i]["relationships"]["paquetes"][j]);
                  descuentos.add(ok[i]["relationships"]["paquetes"][j]);
                }
            }
          }

       



  } catch (e) {
     print("error api");
  }
   
  if(await _sharedPref.contains('address_select')){
    try{
       address.add(await _sharedPref.read('address_select') );
       print('trayendo');
       print(address);
    }catch(e){
      print(e);
      // Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }

  }
 
  
  calculateListCarrito();
   refresh();
   
   setTimeout(()=>{enabled=false,refresh()},1000);
   return;
  try {
      
         ok=await cartaProvider.ListPromociones();
          for (var i = 0; i <  ok.length; i++) {
            for (var j = 0; j < ok[i]["relationships"]["paquetes"].length; j++) {
                if( double.parse(ok[i]["relationships"]["paquetes"][j]["attributes"]["descuento"])>0){
                  //print(ok[i]["relationships"]["paquetes"][j]);
                  descuentos.add(ok[i]["relationships"]["paquetes"][j]);
                }
            }
          }

  } catch (e) {
     print("error api");
  }


   refresh();

  return;
  await userprovider.init(context, await _sharedPref.read('user') ?? {}) ;
  await sliderprovider.init(context,  await _sharedPref.read('user') ?? {});
  await cartaProvider.init(context,  await _sharedPref.read('user') ?? {});
  //slider=await sliderprovider.list();
 
  //carta=new Map<String, dynamic>.from(await cartaProvider.ListPromociones());
 // ResponseApi responseApi=await cartaProvider.ListPromociones();
  //List<String> carta = List<String>.from(await cartaProvider.ListPromociones());
  //carta=await cartaProvider.ListPromociones();
   //ResponseApi responseApi=await cartaProvider.ListPromociones();
   //print(responseApi);
   //final ok=await cartaProvider.ListPromociones();
   //final d=json.decode(json.encode(ok));
   //print(d["data"][0]);
  // print(carta["data"][0]);
  ok=await cartaProvider.ListPromociones();
  for (var i = 0; i <  ok.length; i++) {
    for (var j = 0; j < ok[i]["relationships"]["paquetes"].length; j++) {
        if( double.parse(ok[i]["relationships"]["paquetes"][j]["attributes"]["descuento"])>0){
          //print(ok[i]["relationships"]["paquetes"][j]);
          descuentos.add(ok[i]["relationships"]["paquetes"][j]);
        }
    }
  }
  //print(ok[0]["relationships"]["paquetes"]);

 //ok[0]["relationships"]["paquetes"].forEach((key, val) {
  //listTab.add(val);
  //print(val);
  //promociones.add(val);

 //});
 //promociones2=new Map<String, dynamic>.from(promociones);
 
  //print((slider["data"]));
  //final data=await cartaProvider.ListPromociones();
   //print(data["data"]["attributes"]["title"]);
  //print(data["data"]["relationships"]);
  //print(carta["data"]["relationships"]["paquetes"].length);
  //print('la imagen es');
  //print(promociones.length);
  //print(promociones[1]["attributes"]["imagen"]);
  //print(promociones[0][""]);
  //print(carta["data"]["relationships"]["paquetes"]["0"]["attributes"]);

  if(await _sharedPref.contains('address_select')){
    try{
       address.add(await _sharedPref.read('address_select') );
       print('trayendo');
       print(address);
    }catch(e){
      print(e);
      // Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }

  }
  print('ok');
  refresh();
 //print(slider['data'][0]['attributes']);
}


setTimeout(callback, time) {
  Duration timeDelay = Duration(milliseconds: time);
  return Timer(timeDelay, callback);
}
void login() async{
      

}
void calculateListCarrito() async{
 if(await _sharedPref.contains('order')){
      carrito_sesion=await _sharedPref.read('order');
      //print(data.length);
      //print(data[0]["producto"]);
      //print(carrito_sesion[4]);
      //refresh();
       
   }

}

   logout(){
    _sharedPref.logout(context);
  }

String getDetalle(fami,paq) {
  String comb='';
  for (var i = 0; i < ok[fami]["relationships"]["paquetes"][paq]["relationships"]["detalles"].length; i++) {
   // comb=comb+''+ok[fami]["relationships"]["paquetes"][paq]["relationships"]["detalles"][i]["attributes"]["title"].toString();
     for (var j = 0; j <  ok[fami]["relationships"]["paquetes"][paq]["relationships"]["detalles"][i]["relationships"]["combinaciones"].length; j++) {
       if( ok[fami]["relationships"]["paquetes"][paq]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"]=="1"){
        comb=comb+''+ok[fami]["relationships"]["paquetes"][paq]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto"].toString()+',';
       }
     }
     
    
  }
  return comb;
}

 void scrollDown(index) {
   double altura=250;
 
  for (var i = 0; i <  ok.length; i++) {
     if(i<index){
      final int items=ok[i]["relationships"]["paquetes"].length;
      altura=altura+double.parse(items.toString())*140;
     }


  }


  //print(items);
  /*_controller.animateTo(
    //_controller.position.maxScrollExtent,
    400,
    //500,
    duration: Duration(seconds: 2),
    curve: Curves.fastOutSlowIn,
  );
  */
  controller.jumpTo(altura);
}  

  void openBottomShhet(data){
    Navigator.of(context).pushNamed("client/product_details",arguments:{'id':data});


    
  //  var send=data;
    /*showModalBottomSheet(
      //sDismissible: false,
      //enableDrag: false,
      isScrollControlled: true,
      context: context, 
      builder: (context)=>ClientsProductDetailPage(product:data),
    ).whenComplete(() {
     
    }).then((value) => {aftermodal()});
    */
  }
  void aftermodal(){
     calculateListCarrito();
  }
  void openBottomSliderSheet(idpaquete){

          for (var i = 0; i <  ok.length; i++) {
            for (var j = 0; j < ok[i]["relationships"]["paquetes"].length; j++) {    
                if(ok[i]["relationships"]["paquetes"][j]["id"]==idpaquete){
                  //openBottomShhet(ok[i]["relationships"]["paquetes"][j]);
                  openBottomShhet(ok[i]["relationships"]["paquetes"][j]["attributes"]["paq_tienda_id"]);
                }
               
            }
          }

  }
 void paquetedetalles(product){

  Navigator.of(context).pushNamed("client/product_details",arguments:product);
 }
 void gototest(){
  Navigator.of(context).pushNamed('test');
}
void gotoaddress(){
  Navigator.of(context).pop();
  Navigator.of(context).pushNamed('client/address');
}
void gotohome(){
   Navigator.of(context).pushNamedAndRemoveUntil('client/main',(route)=>false);
}

void gotoWelcome(){
  Navigator.of(context).pop();
  Navigator.of(context).pushNamed('client/home');
}
  void openDrawer(){
     key.currentState?.openDrawer();
     print("abierto");
  }

String setAddrssName(){
  if(address!=null  && address.isNotEmpty)
  {
    if(int.parse(address[0]['ADD_TYPE'])==0){
      return address[0]['ADD_DIR_DOMICILIO'].toString();
    }else{
      return address[0]['ADD_ADI_NOMBRE'].toString();
    }
  }
  return "";



}
 void ShowAddressBottomShet(){
    showModalBottomSheet(
      //sDismissible: false,
      //enableDrag: false,
        shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                ),
         ),
         backgroundColor: Colors.white,
         context: context, 
         builder: (context)=>ClientsMainAddressListPage(),
    );
  }

  void NavigatorGoTo(int val){
      print(val);
      if(val==1){
            scrollDown(0);
      }
      else if(val==2){
        Navigator.of(context).pushNamed('client/list_carrito');
      }else{

      }
  }


}