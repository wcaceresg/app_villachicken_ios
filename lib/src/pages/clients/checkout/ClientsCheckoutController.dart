
import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/clients/checkout/comprobante/ClientsTipoComprobantePage.dart';
import 'package:villachicken/src/pages/clients/checkout/efectivo/ClientsTipoEfectivoPage.dart';
import 'package:villachicken/src/pages/clients/checkout/pasarela/ClientsCheckoutPasarelaPage.dart';
import 'package:villachicken/src/pages/clients/documents/TypeDocumentPage.dart';
import 'package:villachicken/src/providers/entidades_provider.dart';
import 'package:villachicken/src/providers/order_provider.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/functions.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/document_check.dart';
import 'package:villachicken/src/widgets/document_legal.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientsCheckoutController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 
 int counter=1;
 double Price=0.00;
 double pagoSoles=0.00;
 double vueltoSoles=0.00;
 SharedPref _sharedPref=new SharedPref();
 List selectedProducts=[];
 List carrito_sesion=[];
 List address=[];
 EntidadProvider entidadProvider=new EntidadProvider();
 OrderProvider orderProvider=new OrderProvider();
 List tipo_comprobante=[];
 int  tipo_comprobante_select=0;
 String tipo_comprobant_nombre='BOLETA SIN DNI';
 String documento="77777777";
 String documento_name="VARIOS";
 String documento_address="";


List medio_pago=[];
int  medio_pago_select=3;
late Map<String, dynamic> medio_pagos;
 late CameraPosition     initialPosition=CameraPosition(
    //target: LatLng(-12.1056334,-76.9686237),
    target: LatLng(-12.0629701, -76.95122529999999),
    zoom: 15

  );
Completer<GoogleMapController> _mapController=Completer();
final Set<Marker> markers = {};
BitmapDescriptor markericon=BitmapDescriptor.defaultMarker;

final GlobalKey<DocumentCheckWidgetState> checkTerKey = GlobalKey<DocumentCheckWidgetState>();
final GlobalKey<DocumentCheckWidgetState> checkPolKey = GlobalKey<DocumentCheckWidgetState>();
bool checkTerminos=false;
bool checkPoliticas=false;
double recargo_delivery=Environment.recargo;

Future init(BuildContext context,Function refresh) async{
  this.context=context;
   this.refresh=refresh;
     try {
           await entidadProvider.init(context,  User.fromJson(await _sharedPref.read('user') ?? {}));
      } catch (e) {
          print("error entidad provider");
      }
     try {
           await orderProvider.init(context,   User.fromJson(await _sharedPref.read('user') ?? {}));
      } catch (e) {
          print("error order provider");
      }

    if(await _sharedPref.contains('order')){
        carrito_sesion=await _sharedPref.read('order');
        print(carrito_sesion);
        
    }

    if(await _sharedPref.contains('address_select')){
      try{
        address.add(await _sharedPref.read('address_select') );
        
    try {
        animateCameraToPosition(num.parse(address[0]['ADD_LATITUD'].toString()).toDouble(),num.parse(address[0]['ADD_LONGITUD'].toString()).toDouble());
    } catch (e) {
       print('error'+e.toString());
    }

      markers.add(
         Marker(
          markerId: MarkerId("id-1"),
          //position: LatLng(-12.058013, -77.041482),
         // position: LatLng(-12.0629701, -76.95122529999999),
          position: LatLng(num.parse(address[0]['ADD_LATITUD'].toString()).toDouble(),num.parse(address[0]['ADD_LONGITUD'].toString()).toDouble()),
          //icon: markericon,
        ));
      }catch(e){
        print(e);
        // Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
      }
    }

    try {
          var request=await entidadProvider.GetEntidadByName('ENTIDADCOMPROBANTE');
          print((request["data"]).length);
          print(request["data"][0]["ENT_NOMBRE"]);
            tipo_comprobante.add({
                    "id": 0,
                  "ENT_NOMBRE": "BOLETA SIN DNI"
            });
            for (var i = 0; i < request["data"].length; i++) {
                  tipo_comprobante.add({
                    "id": request["data"][i]["id"],
                  "ENT_NOMBRE": request["data"][i]["ENT_NOMBRE"]
            });      
            }
          //  tipo_comprobante=request["data"];
            print(tipo_comprobante);
            //print('tipo de comprobante');
          
            //print(tipo_comprobante);

    } catch (e) {
      print("error api tipo_comprobante");
    }

    try {
          var request=await entidadProvider.GetEntidadByName('ENTIDTARJETA');
            for (var i = 0; i < request["data"].length; i++) {
            
                if((request["data"][i]["id"])==1  ){                        
                }else if((request["data"][i]["id"])==2){
                }else{
                  
                if(address!=null  && address.isNotEmpty)
                {
              
                  if(int.parse(address[0]['ADD_TYPE'])==0){
                       medio_pago.add(request["data"][i]);  
                  }else{
                       if((request["data"][i]["id"])==3){
                             medio_pago.add(request["data"][i]);  
                       }
                  }
                }

                 
                }
                                
                      
            }

    } catch (e) {
      print("error api tipo_comprobante");
    }
     print("***********************************ADDRESSSSSSSSSSS *******");


       if(int.parse(address[0]["ADD_TYPE"])==0){
            if(await _sharedPref.contains('cobertura')){
                  final obj=await _sharedPref.read('cobertura');
                recargo_delivery=obj['recargo'];    
            }
       }else{
        recargo_delivery=0;
       } 



   CalcularPrecio();
  refresh();

}


void sum_cantidad(indicador) async{
  int cant=carrito_sesion[indicador]["cantidad"];
  cant++;
  double nuevoprecio=num.parse(carrito_sesion[indicador]["pu"]).toDouble()*cant;
  carrito_sesion[indicador]["cantidad"]=cant;
  carrito_sesion[indicador]["precio"]=nuevoprecio.toStringAsFixed(2);
   _sharedPref.save('order',this.carrito_sesion);
  CalcularPrecio();
}
void rest_cantidad(indicador) async{
  int cant=carrito_sesion[indicador]["cantidad"];
  if(cant>1){
   cant--;
  double nuevoprecio=num.parse(carrito_sesion[indicador]["pu"]).toDouble()*cant;
  carrito_sesion[indicador]["cantidad"]=cant;
  carrito_sesion[indicador]["precio"]=nuevoprecio.toStringAsFixed(2);
  _sharedPref.save('order',this.carrito_sesion);
  CalcularPrecio();

  }
  

}
 void deletedItem(indicador) async{
   carrito_sesion.remove(indicador);
   _sharedPref.save('order',this.carrito_sesion);
   CalcularPrecio();
 }
void CalcularPrecio(){
    this.Price=0;
  if(carrito_sesion.length>0){
    for (var i = 0; i < this.carrito_sesion.length; i++) {
        this.Price+=num.parse(carrito_sesion[i]["pu"]).toDouble()*num.parse(carrito_sesion[i]["cantidad"].toString()).toInt();

    }

  } 
    FunctionsUtil fn=new FunctionsUtil(recargo_delivery);
    this.Price=fn.getTotal(carrito_sesion);
    //this.Price=double.parse(this.Price.toStringAsFixed(2));
    refresh();
}


  void onMapCreated(GoogleMapController controller){
   // controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }
  Future animateCameraToPosition(double lat,double lng) async{
    GoogleMapController controller=await _mapController.future;
    if(controller !=null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:LatLng(lat,lng),
          //zoom:17,
          zoom: 15,
          bearing: 0
        )
      ));
    }
  }
  
 void addCustomIcon(){
  BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/').then((icon) => {markericon=icon});
 }
  void openModalTipoComprobante(){
    //this.pax_modal=1;
    var send={
      'tipo_comprobante':this.tipo_comprobante,
      'tipo_comprobante_select':this.tipo_comprobante_select,
      'documento':this.documento,
      'documento_name':this.documento_name,
      'documento_address':this.documento_address
    };
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      context: context, 
      builder: (context)=>ClientsTipoComprobantePage(arguments: send),
    ).whenComplete(() {
     }).then((value) => {set_value_response(value)});

  }
  void set_value_response(data){
     if(data!=null){
       tipo_comprobante_select=data["tipo_comprobante"];
       tipo_comprobant_nombre=data['name'];
       documento=data["documento"];
       documento_name=data["documento_nombre"];
       documento_address=data["documento_address"];
       refresh();

     }

  }

  void send_data() async{
    if(!checkTerminos){
      mySnackbar.show(context, "Acepte términos y condiciones");
      return;
    }
    if(!checkPoliticas){
      mySnackbar.show(context, "Acepte politicas de privacidad");
      return;
    }

    int indexPayMethod = medio_pago.indexWhere((f) => f['id'] == medio_pago_select);
    var jsonSave={
      'comprobante':{
        'id':tipo_comprobante_select,
        'name':tipo_comprobant_nombre,
        'document':documento,
        'document_name':documento_name,
        'document_address':documento_address,
      },
      'total':Price.toString(),
      'sencuencial':'00000000', //secuencial
      'payment_method': {
        'id': medio_pago[indexPayMethod]['id'], //4,5,6
        'id_money':1,
        'name':medio_pago[indexPayMethod]['ENT_NOMBRE'], // visa ocntra entrega
        'money_name':'SOLES',
        'operacion':'000000000000000',
        'transaction_id':'00000000',  //tarjeta
        'monto':double.parse(Price.toStringAsFixed(2))
      },
      'efectivo':{
        'payment':pagoSoles,
        'vuelto':vueltoSoles
      }
    };
     _sharedPref.save('order_resume', jsonSave);
    /*if(await _sharedPref.contains('order_resume')){
        var data=await _sharedPref.read('order_resume');
        data["comprobante"]["name"]="select";
  
    }
    */
    var response={
        'status':0,
        'message':Catalogs.order_response_failed
    };
    if(medio_pago_select==3){
        _sharedPref.save('order_response', response);
        _sharedPref.save('total', Price.toString());
        Navigator.pushNamed(context, 'client/checkout/pasarela');
    }else{
       _onLoading();
       try {
        final order= await orderProvider.store();
             Navigator.pop(dialogContext);
             if(order==200){
              response['status']=1;
              response['message']=Catalogs.order_response_success;
               //  mySnackbar.show(context, 'orden enviado');
             }else{
              response['status']=0;
              response['message']=Catalogs.order_response_failed;              
             }
      
       } catch (e) {
            //Navigator.pop(dialogContext);
            
            mySnackbar.show(context,e.toString());
           
       }finally{
             _sharedPref.save('order_response', response);
              Navigator.pushNamed(context, 'client/checkout/response');
       }
       

    }
  }

   void openBottomShhet(data) {
  //  var send=data;
    showModalBottomSheet(
      //sDismissible: false,
      //enableDrag: false,
      isScrollControlled: true,
      context: context, 
      builder: (context)=>ClientsCheckoutPasarelaPage(),
    ).whenComplete(() {
     
    }).then((value) => {});
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
String setTypeOrder(){
  if(address!=null  && address.isNotEmpty)
  {
    if(int.parse(address[0]['ADD_TYPE'])==0){
      return Environment.typeDelivey;
    }else{
       return Environment.typeLLevar;
    }
  }
  return "";

 }
 void listenTypeMethod(){
   if(medio_pago_select==6){
    openModalEfectivo();
   }
 }
 void openModalEfectivo(){
    var send={
      'monto':Price,
    };
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      context: context, 
      builder: (context)=>ClientsTipoEfectivoPage(arguments: send),
    ).whenComplete(() {
     }).then((value) => {efectivoCallBack(value)});


 }
 void efectivoCallBack(data){
  if(data!=null){
      pagoSoles=data["payment_soles"];
      vueltoSoles=data["payment_vuelto"];
  }

 }

  Future dialog(message){
    return showDialog(context: context, 
       barrierDismissible: false,
       builder: (context)=>AlertDialog(
              content: Container(
                height: 300,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left:20,right: 20),
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/img/success.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Container(
                        //padding: EdgeInsets.only(left:20,right: 20),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),

      // content: Text('el texto del cuadro'),
       actions: <Widget>[
        TextButton(onPressed:() {
             //Navigator.of(context).pop('Aceptar');
             SystemNavigator.pop();
        }, child: Text('Aceptar'))

        
       ],
    ));
  }
void openModalTerminos(value){
   documentLegalWidget.show(
          context: context,
          child:  TypeDocumentPage(arguments: value,),
          onComplete: () {
          },
          ondata: (data){
           if(data!=null){
             if(value==1){
                 checkTerminos=data['status'];
                 checkTerKey.currentState?.setCheckValue(data['status']); 
             }else{
                 checkPoliticas=data['status'];
                 checkPolKey.currentState?.setCheckValue(data['status']); 
             }
             refresh();
           }
          }
    );                              
}
void close_page(){
  Navigator.of(context).pop();
}


}