import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/pages/login/socials/GoogleController.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
class WelcomeController{
late BuildContext context;
UserProvider userprovider=new UserProvider();
ApiGoogleController apiGoogleController=new ApiGoogleController();
SharedPref _sharedPref=new SharedPref(); 
Future init(BuildContext context) async{
this.context=context;
loginGmailProvider();
}
void goToLoginEmail(){
    Navigator.of(context).pushNamed("login");
}
void requestLogin() async{
  await apiGoogleController.login();
}
Future loginGmailProvider() async{
  try {await apiGoogleController.init(context) ;} 
  catch (e) {print(e);}
}



}