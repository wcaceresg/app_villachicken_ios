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
class SecuencialProvider{
   String _url= Environment.API_DELIVERY;
   late BuildContext context;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     this.sessionUser=sessionUser;
   }
   Future listar() async{
          try{
            var response = await http.get(Uri.parse('$_url/api/api/v1/secuencials'), headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer ${this.sessionUser.token}',
            });
           String jsonsDataString = await response.body.toString();
           int statusCode = response.statusCode;
            if(statusCode==200){
                 final jsonData = jsonDecode(jsonsDataString);  
                  return jsonData["data"];
            }else{
                   mySnackbar.show(context, "ERROR SERVIDOR");
                   return null;
            }


          }catch (e) {
                   mySnackbar.show(context, ""+e.toString());
                  return null;                
          } 
   }
}