
import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/favorites_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/traits/functions.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';

import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientProductsDetailsController{
late BuildContext dialogContext;
 late BuildContext context;
 late Function refresh;
 int counter=1;
 late  double productPrice;
 SharedPref _sharedPref=new SharedPref();
List selectedProducts=[];
late String dt;
String NombreCombinacion="";
double price=0;
int cantidad=1;
String NombrePaquete="";
List carrito_sesion=[];
 // radio button combination
 List<String> prueba=[];
 List<String> prueba2=[];
 List<String> prueba3=[];
 List<String> prueba4=[];
 int itemprueba=0;
 TextEditingController comentarioController=new TextEditingController();
 bool enabled = true;
 UserProvider userprovider=new UserProvider();
 FavoriteProvider favoritesProvider=new FavoriteProvider();
Future init(BuildContext context,Function refresh,data) async{
  this.context=context;
   this.refresh=refresh;
   this.selectedProducts.add(data);
   this.price=double.parse(this.selectedProducts[0]["attributes"]["precion_base"]);
   this.NombrePaquete=this.selectedProducts[0]["attributes"]["title"];
   calcular_nombre_combinacion();
   itemprueba=0;
   cantidad=1;
   if(await _sharedPref.contains('order')){
      carrito_sesion=await _sharedPref.read('order');
   }
   

  refresh();
  setTimeout(()=>{enabled=false,refresh()},1000);
}
Future initReloadToken() async{
    try { await userprovider.reload_token();} catch (e) { print(e);}
}
Future initFavoritesProvider() async{
  try {await favoritesProvider.init(context,  User.fromJson(await _sharedPref.read('user') ?? {}));
  } catch (e) { print(e);
  }
}

void calcular_nombre_combinacion(){
     int count=0;
     NombreCombinacion='';
     double precio_adicional=0;
     double paquete_precio=double.parse(this.selectedProducts[0]["attributes"]["precion_base"]);
     for(int i=0;i<selectedProducts[0]["relationships"]["detalles"].length;i++)
     {
       for(int j=0;j<selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"].length;j++)
       {
         if(selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"]=="1")
         {
             precio_adicional+=double.parse(selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["porecio_adicional"]);
            if(count==0){
               NombreCombinacion+=selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto"];
            }else{
              NombreCombinacion+="+"+selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto"];
            }       
            count++;
         }
                  
        }
    }
    this.price=(paquete_precio+precio_adicional)*this.cantidad;
    //this.price=num.parse(this.price.toStringAsFixed(2));
    this.price=double.parse(this.price.toStringAsFixed(2));

}
void sum_cantidad(){
  this.cantidad++;
  calcular_nombre_combinacion();
   refresh();
}
void rest_cantidad(){
  if(this.cantidad>1){
     this.cantidad--;
     calcular_nombre_combinacion();
     refresh();
  }

}
void agregar_carrito() async{
  //print(this.selectedProducts[0]);
  int index_bom=0;
  //int cantidad=0;
  List items=[];
  List Paquete_select=[];
  for (var i = 0; i < this.selectedProducts[0]["relationships"]["detalles"].length; i++) {
    for (var j = 0; j <this.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"].length ; j++) {

         if(selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"]=="1"){
           final it={
                    "det_id":this.selectedProducts[0]["relationships"]["detalles"][i]["id"],
                    "comb_id":this.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["id"],
                    "prod_id":this.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["producto_id"],
                    "precio":this.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["porecio_adicional"]
                  };
           Paquete_select.add(it); 
         }
       
    }

  }
  String comentario=comentarioController.text; 
  final myJson = {
    "id": this.selectedProducts[0]["id"],
    "cantidad": this.cantidad,
    "producto":this.selectedProducts[0]["attributes"]["title"],
    "imagen":this.selectedProducts[0]["attributes"]["imagen"],
    "pu":this.selectedProducts[0]["attributes"]["precion_base"],
    "precio":this.price,
    "combinacion":this.NombreCombinacion,
    "paq_detalle":Paquete_select,
    "observacion":""+comentario.toString(),
    "numero_bolsas":this.selectedProducts[0]["attributes"]["numero_bolsas"],
  };
  //items.add(myJson);
  
  //print(carrito_sesion);

   if(await _sharedPref.contains('order')){
      carrito_sesion=await _sharedPref.read('order');
   }
   carrito_sesion.add(myJson);
  _sharedPref.save('order', carrito_sesion);
  Navigator.of(context).pushNamed("client/list_carrito");
  //Navigator.pushNamedAndRemoveUntil(context, 'client/list_carrito', (route) => false);
}
void storeFavorite() async{
   _onLoading();
   initReloadToken().then((value) => {
      Navigator.pop(dialogContext),
      initFavoritesProvider().then((rest)=>{
              StoreFavorites(this.selectedProducts[0]['id'])
      })
   }).catchError((error)=>{
      Navigator.pop(dialogContext),
      mySnackbar.show(context, Catalogs.error_500)
   });
}
Future StoreFavorites(id_paquete) async{

 await favoritesProvider.register(id_paquete);
    
       
    

}


void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return LoaderWidget();
    },
  );
}

 void close_page(){
   Navigator.pop(context);
 }

}