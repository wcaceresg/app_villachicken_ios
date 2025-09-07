import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';//basename
class SliderProvider{
   String _url= Environment.API_DELIVERY;
   String _api='/api/api/v1/sliders';
   late BuildContext context;
   //String token;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future list() async{
          try{
          var response = await http.get(
              Uri.parse('$_url$_api'),

          );
            return json.decode(response.body);
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
                  print('error ES:$e');
                  return null;
          }          
   }
  
}