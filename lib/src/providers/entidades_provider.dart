import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';//basename
class EntidadProvider{
   String _url= Environment.API_DELIVERY;
   late BuildContext context;
   //String token;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future GetEntidadByName(String name) async{
    
          try{
          var response = await http.get(
              Uri.parse('$_url/api/entidades/$name/listar'),

          );
          return json.decode(response.body);
            //String jsonsDataString = await response.body.toString();
            //final jsonData = jsonDecode(jsonsDataString);
            // return jsonData["data"];

          }catch (e) {
                  print('error ES:$e');
                  return null;
          }          
   }
  
}