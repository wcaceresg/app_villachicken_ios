
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/order_provider.dart';
import 'package:villachicken/src/providers/secuencial_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';

import 'package:webview_flutter/webview_flutter.dart';
class ClientCheckOutPasarelaController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 int counter=1;
 SharedPref _sharedPref=new SharedPref();
 List selectedProducts=[];
 List carrito_sesion=[];
 bool enabled = true;
 String total="";
 UserProvider userprovider=new UserProvider();
 SecuencialProvider secuencialProvider=new SecuencialProvider();
 OrderProvider orderProvider=new OrderProvider();
 late  WebViewController controller=new WebViewController();
 var order_resume={};
 var response_api={};
 var merchant_id=Environment.VISA_MERCHANT;
Future init(BuildContext context,Function refresh) async{
   this.context=context;
   this.refresh=refresh;
   controller=controller;
   initOrderResponse();
   initOrderProvider();
   initUserProvider();
   init_Merchant();
   init_order();
   initSecuencialProvider().then((value) => {
      RequestSecuencial().then((response) =>{
        init_payment()
      } )
   });



}
void store(data) async{
  response_api['status']=0;
  try {
    var response = jsonDecode(data) ;
    bool is_error = response.containsKey("errorCode");
    bool is_order = response.containsKey("order");
        if(is_error){
           print('*****************************TRANSACCIÓN NO VALIDA****************');
           print(response["errorCode"]);
           print(response["errorMessage"]);
              response_api['message']=response["errorMessage"].toString();

        }else{
          if(is_order){
              print('*****************************TRANSACCIÓN EXITOSA****************');
              //print(response["order"]["transactionId"]);
              //print(response["order"]["traceNumber"]);
              if(response.containsKey('dataMap')){
                 response_api['status']=1;
                 if(response["dataMap"]["BRAND"]!=null){
                        //print(response["dataMap"]["BRAND"]);
                        String nombre_tarjeta="PAGO EN LINEA ${response["dataMap"]["BRAND"].toString()} ${response["dataMap"]["CARD"].toString()}(L) REF:${response["order"]["traceNumber"].toString()}  - PEDIDO CANCELADO";
                         order_resume["payment_method"]["name"]=nombre_tarjeta;
                 }
                   if(response["dataMap"]["CARD"]!=null){
                       // print(response["dataMap"]["CARD"]);  
                 }               
              }
               order_resume["payment_method"]["operacion"]=response["order"]["traceNumber"].toString();
               order_resume["payment_method"]["transaction_id"]=response["order"]["transactionId"].toString();
              _sharedPref.save('order_resume', order_resume);
             // print(order_resume);

              final order= await orderProvider.store();
              if(order==200){
                response_api['status']=1;
                response_api['message']=Catalogs.order_response_success;
                //  mySnackbar.show(context, 'orden enviado');
              }else{
                response_api['status']=0;
                response_api['message']=Catalogs.order_response_failed;              
              }
      




          }else{
                print('*****************************TRANSACCIÓN NO VALIDA****************');
               // print('consultar con su codigo comercio');
               response['message']=Catalogs.pasarela_response_failed;

          }
  
        }
     
  } catch (e) {
        //print('ERROR PARSE 500 JSON RESPONSE');
         response_api['message']=Catalogs.pasarela_response_failed;
         
  }finally{
              print('finallyyyyyyyyyyyyyyyyyyyyyyy');
              print(response_api);
              _sharedPref.save('order_response', response_api);
              Navigator.pushNamed(context, 'client/checkout/response');
  }


}
Future initOrderResponse() async{
  try {
    if(await _sharedPref.contains('order_response')){
         response_api=await _sharedPref.read('order_response');
    }
    } 
  catch (e) {print(e);}
}
Future initUserProvider() async{
  try {await userprovider.init(context,User.fromJson(await _sharedPref.read('user') ?? {})) ;} 
  catch (e) {print(e);}
}
Future initSecuencialProvider() async{
  try {await secuencialProvider.init(context,User.fromJson(await _sharedPref.read('user') ?? {}));
  } 
  catch (e) {print(e);}
}
Future initOrderProvider() async{
  try {await orderProvider.init(context,User.fromJson(await _sharedPref.read('user') ?? {}));
  } 
  catch (e) {print(e);}
}

Future init_order() async{
  try {
      if(await _sharedPref.contains('total')){
      total=await _sharedPref.read('total');
     
      } 
     if(await _sharedPref.contains('order_resume')){
         order_resume=await _sharedPref.read('order_resume');
     }

  } catch (e) {
      print('error');
  }
}
Future update_order(secuencial) async{
  try {
         order_resume["sencuencial"]=secuencial.toString();
         _sharedPref.save('order_resume', order_resume);

          print('secuencial apiAAAAAAAAAA');print(order_resume);
  
  } catch (e) {
      print('error');
  }
}
Future RequestSecuencial() async{
  try 
  {     
         await secuencialProvider.listar().then((value) => { 
          update_order(value["code_operacion"])
           //favorites=value,
           //Navigator.pop(dialogContext),
          // enabled=true,
         // refresh()
           
         });
         
  } catch (e) {
         Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}
 Future init_Merchant() async{
            if(await _sharedPref.contains('cobertura')){
                  final obj=await _sharedPref.read('cobertura');
                  if(!Environment.isTest){
                      merchant_id=obj['merchant_id']; 
                   //print(merchant_id); 
                   //
                   // print("obteniendo datos pasarela");
                   // print(obj);                  
                  }
                  //print("/***************** merchant id **************************/");
                   //merchant_id=obj['merchant_id']; 
                   //print(merchant_id);  
            }

 }
 init_payment() async{
    controller=WebViewController()..loadRequest(Uri.parse(Environment.URL_PAYMENT));
    controller..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
        
        },
        onPageFinished: (url) => {
                injectJavascript(controller)
        }
      )

    )..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel("ResponseTransaction", onMessageReceived: (JavaScriptMessage message)
    {store(message.message);
    });
     refresh();

}
injectJavascript(WebViewController controller) async {
  try {
      controller.runJavaScript('''
       var checkbox = document.getElementById("checkbox_terminos");
        checkbox.addEventListener('change', function() {
          if (this.checked) {
            pagar("${order_resume["sencuencial"]}", ${total.toString()}, "${merchant_id}", "192.168.1.100", "villaapp@gmail.COM", 0)
          } else {
           // alert('no check');
          }
        });
''');  
  } catch (e) {
    
  }

  }




}