import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ApiGoogleController{
late BuildContext context,dialogContext;
UserProvider userprovider=new UserProvider();
SharedPref _sharedPref=new SharedPref(); 
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: "57287907836-a1ijdl6mr2d46dno88c82pae2vg4nnbv.apps.googleusercontent.com",
  scopes: ['email', 'profile', 'openid'],
);


Future  init(BuildContext context) async {
     this.context=context;
     //this.token=token;

   }
  void goToLoginEmail(){
      Navigator.of(context).pushNamed("login");
  }
  Future<void> login() async {
    try {
      final user = await _googleSignIn.signIn();
      print("Usuario logueado: ${user?.displayName}");
      print(user?.displayName);
      print(user?.email);
      print(user?.id);
      register(user);


    } catch (error) {
      print("Error al iniciar sesión: $error");
    }
  }
  void register(user) async{
        _onLoading();
         try {
           ResponseApi responseApi=await userprovider.storeGoogle(user?.email,user?.displayName,user?.id);
            Navigator.pop(dialogContext);           
            if(responseApi.error!=''){
                  var response_error="";
                  for (String error in responseApi.error) {
                      response_error=response_error+","+ error;
                    }
                  mySnackbar.show(context, response_error.toString());
                  return; 
              
            }else{
                   if(responseApi.code==201)
                   {
                        User user=User.fromJson(responseApi.data);
                        _sharedPref.save('user', user.toJson());
                        _sharedPref.save('user-pwd', '123456');
                        _sharedPref.save('user-type',  "google");
                        Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
                   }
            }          
         } catch (e) {
             Navigator.pop(dialogContext);
            mySnackbar.show(context, Catalogs.error_500);
         }   

  }
  Future<void> logout() async {
    try {
      await await _googleSignIn.signOut();
      print('Usuario deslogueado');
    } catch (error) {
      print('Error al desloguear: $error');
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