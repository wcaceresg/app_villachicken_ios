import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
class ClientsCheckoutResponseContnroller{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 SharedPref _sharedPref= new SharedPref();
 var response={};
Future init(BuildContext context,Function refresh) async{
  this.context=context;
   this.refresh=refresh;
 

    if(await _sharedPref.contains('order_response')){
         response=await _sharedPref.read('order_response');
        print('datosssssssssssssssssssss response');
        print(response['status']);
        print(response['message']);
          refresh();
    }


}
void ValidatePayment() async{
   if(response['status']==1){
         Navigator.pushNamedAndRemoveUntil(context, 'client/orders', (route) => false);
   }else{
         Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
   }

}

}