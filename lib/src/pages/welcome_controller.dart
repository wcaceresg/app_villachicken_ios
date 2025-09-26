import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/login/socials/GoogleController.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class WelcomeController{
late BuildContext context;
late BuildContext dialogContext;
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
Future HandleLoginApple() async{
  try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
              //print("User ID: ${credential.userIdentifier}");
              //print("Email: ${credential.email}");
              //print("Full Name: ${credential.givenName} ${credential.familyName}");
              //print("Identity Token: ${credential.identityToken}");
              //print("Authorization code Token: ${credential.authorizationCode}");
          _onLoading();
        try{  
              ResponseApi responseApi=await userprovider.loginApple
              ("${credential.email}",
              "${credential.givenName} ${credential.familyName}", 
              "${credential.userIdentifier}", 
              "${credential.authorizationCode}", 
              "${credential.identityToken}");
               Navigator.pop(dialogContext);
              if(responseApi.code==201)
              {
                User user=User.fromJson(responseApi.data);
                _sharedPref.save('user', user.toJson());
                _sharedPref.save('user-pwd',  "${credential.userIdentifier}");
                Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
              }else
              {
                mySnackbar.show(context, responseApi.error);
              }
        }catch(e){
              mySnackbar.show(context, "Ocurrió un problema al iniciar sesión. Por favor, inténtalo de nuevo.");
        }

  } 
  catch (e) {
             mySnackbar.show(context, "Respuesta inválida del servidor de Apple.");
  }
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



}