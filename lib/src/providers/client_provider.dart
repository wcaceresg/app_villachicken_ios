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
class ClientProvider{
   String _url= Environment.API_DELIVERY;
   late BuildContext context;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future search(document) async{
       try{
          var response = await http.post(
              Uri.parse('$_url/api/client/search'),
              headers:{ "Content-Type": "application/x-www-form-urlencoded" } ,
              body: { "documento":document.toString() },
              encoding: Encoding.getByName("utf-8")
          );
           int statusCode = response.statusCode;
           String jsonsDataString = await response.body.toString();
           final jsonData = jsonDecode(jsonsDataString);
            //print(jsonData);
            if(statusCode==200){
              //mySnackbar.show(context,jsonData);
            }
            return jsonData['data'];
        }catch (e) {
              mySnackbar.show(context, "errors"+e.toString());
              return e;
        } 
   }
   
}