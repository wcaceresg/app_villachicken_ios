
import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/shared_pref.dart';

class ClientsRegisterController{
late BuildContext context;
late Function function;
 SharedPref _sharedPref=new SharedPref();
 List carrito_session=[];
 bool enabled=true;
 Future init(BuildContext context,Function refresh) async{
   this.context=context;
   //this.refresh=refresh;
   
 }
}