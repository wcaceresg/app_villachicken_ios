import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';//basename
class UserProvider{
   String _url= Environment.API_DELIVERY;
   String _api='/api/login';
   late BuildContext context;
   //String token;
   late User sessionUser;
   SharedPref _sharedPref=new SharedPref();
   Future  init(BuildContext context,User sessionUser) async{
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future<ResponseApi> login(String email,String password) async{
          try{
          var response = await http.post(
              Uri.parse('$_url$_api'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
              body: { "tipo_login":"0","email": '$email',"password": '$password'},
              encoding: Encoding.getByName("utf-8")
          );
           print(response);
          if(response.statusCode==201){
            final data=json.decode(response.body);
           
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }else{
            final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }
          }catch (e) {
                  print('error ES:$e');
                  //return null;
                   return ResponseApi.fromJson({});
          }          
   }


  Future reload_token() async{
  if(await _sharedPref.contains('user')){
    try{
          User user=User.fromJson(await _sharedPref.read('user') ?? {});
          final pwd=await _sharedPref.read('user-pwd');
          var response = await http.post(
              Uri.parse('$_url$_api'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
              body: { "tipo_login":"0","email": user.user.email,"password": pwd},
              encoding: Encoding.getByName("utf-8")
          );
          if(response.statusCode==201){
            final data=json.decode(response.body);
            //print(data);
             ResponseApi responseApi= ResponseApi.fromJson(data);

            if(responseApi.code==201)
            {
              User user=User.fromJson(responseApi.data);
              _sharedPref.save('user', user.toJson());
            
               print('Token reLogeado Correctamente');
               //mySnackbar.show(context, 'Token reLogeado Correctamente');
               print(user.toJson());
            }else{
              Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
            }
          }else{
            final data=json.decode(response.body);
               print('Error al relogear el Token');
               print(data); 
          }
    }catch(e){
     // mySnackbar.show(context, 'error del servidor');
     // print('errorr');
      print('error al traer el reload token'+e.toString());

     //  Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }

  }
          
   }

     Future<ResponseApi> create(String email,String nombre,String documento,String apellido,String password,String Fecha,String genero) async{
          try{
          var response = await http.post(
              Uri.parse('$_url/api/register'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
              body: { 
                "nombres":""+nombre,
                "apellidos":""+apellido,
                "num_docu":""+documento,
                "genero": ""+genero,
                "nacimiento":""+Fecha,
                "tip_docu": "1",
                "name":""+email,
                "email":""+email,
                "password":""+password,
                "password_confirmation":""+password,
                },
              encoding: Encoding.getByName("utf-8")
          );
             print("response backend store ****************************");
             print(response.body);
             print("#status code"); // 400 error
             print(response.statusCode);
             final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 

          /*if(response.statusCode==201){
            final data=json.decode(response.body);
            //print(data);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }else{
            final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }
          */
          }catch (e) {
                  print('error ES******************:$e');
                  print(e);
                  return ResponseApi.fromJson({});

          }          
   }
     Future<ResponseApi> storeGoogle(String email,String nombre,String id) async{
          try{
          var response = await http.post(
              Uri.parse('$_url/api/register'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
              body: { 
                "nombres":""+nombre,
                "genero": "1",
                "tip_docu": "1",
                "name":""+email,
                "email":""+email,
                "password":"123456",
                "password_confirmation":"123456",
                "google_id":id,
                },
              encoding: Encoding.getByName("utf-8")
          );
             print("response backend store ****************************");
             print(response.body);
             print("#status code"); // 400 error
             print(response.statusCode);
             final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 

          /*if(response.statusCode==201){
            final data=json.decode(response.body);
            //print(data);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }else{
            final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }
          */
          }catch (e) {
                  print('error ES******************:$e');
                  print(e);
                  return ResponseApi.fromJson({});

          }   



   }
     Future<ResponseApi> loginApple(String email,String nombre,String id_apple,String code,String token) async{
          try{
          var response = await http.post(
              Uri.parse('$_url/api/register'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
              body: { 
                "nombres":""+nombre,
                "genero": "1",
                "tip_docu": "1",
                "name":""+email,
                "email":""+email,
                "password":"123456",
                "password_confirmation":"123456",
                "codigo_autorizacion_apple":""+code,
                "token_apple":""+token,
                "id_user_apple":id_apple,
                },
              encoding: Encoding.getByName("utf-8")
          );
             print("response backend store ****************************");
             print(response.body);
             print("#status code"); // 400 error
             print(response.statusCode);
             final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 

          /*if(response.statusCode==201){
            final data=json.decode(response.body);
            //print(data);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }else{
            final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }
          */
          }catch (e) {
                  print('error ES******************:$e');
                  print(e);
                  return ResponseApi.fromJson({});

          }   

          
                 
   }

}