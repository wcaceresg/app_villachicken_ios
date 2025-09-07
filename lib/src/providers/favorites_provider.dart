import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';//basename
class FavoriteProvider{
   String _url= Environment.API_DELIVERY;
   late BuildContext context;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future listar() async{
          try{
            var response = await http.get(Uri.parse('$_url/api/favorites'), headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer ${this.sessionUser.token}',
            });
          String jsonsDataString = await response.body.toString();
          final jsonData = jsonDecode(jsonsDataString);  
                  return jsonData["data"];
          }catch (e) {
                   print('error ES:$e');
                  return null;                
          } 
        
   }
   
   Future register(id_paquete) async{
       try{
          var response = await http.post(
              Uri.parse('$_url/api/favorites'),
              headers:{ "Content-Type": "application/x-www-form-urlencoded", 'Authorization': 'Bearer ${this.sessionUser.token}', } ,
              body: { "id_paquete":id_paquete.toString() },
              encoding: Encoding.getByName("utf-8")
          );
           int statusCode = response.statusCode;
           String jsonsDataString = await response.body.toString();
           final jsonData = jsonDecode(jsonsDataString);
            if(statusCode==201){
              mySnackbar.show(context,jsonData);
            }
            return jsonData;
        }catch (e) {
              mySnackbar.show(context, "error"+e.toString());
              return e;
        } 
   }
     Future delete(id) async{
       try{
          var response = await http.delete(
              Uri.parse('$_url/api/favorites/'+id.toString()),
              headers:{  'Authorization': 'Bearer ${this.sessionUser.token}', } ,
          );
           int statusCode = response.statusCode;
           String jsonsDataString = await response.body.toString();
           final jsonData = jsonDecode(jsonsDataString);
            if(statusCode==201){
                mySnackbar.show(context,jsonData);
            }
            return jsonData;
        }catch (e) {
              mySnackbar.show(context, "error"+e.toString());
              return e;
        } 
   }
}