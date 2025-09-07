import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';//basename
class CartaProvider{
   String _url= Environment.API_DELIVERY;
   //String _api='/api/api/v1/cartas/13';
  // String _api='/api/api/v1/productos/CANAL-1012/TI-1500';

   String _api='/api/api/v2/productos/CANAL-1012/TI-1500';
   late BuildContext context;
   //String token;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future ListPromociones() async{
          try{
          var response = await http.get(
              Uri.parse('$_url$_api'),

          );
          String jsonsDataString = await response.body.toString();
          final jsonData = jsonDecode(jsonsDataString);
             return jsonData["data"];
             // return data;      
           //return response.body;
           // return json.decode(response.body);
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

   Future listar() async{
          try{
          var response = await http.get(
               Uri.parse('$_url'+'/api/api/v2/productos/CANAL-1012/TI-1500'),

          );
          String jsonsDataString = await response.body.toString();
          final jsonData = jsonDecode(jsonsDataString);
             return jsonData["data"];
             // return data;      
           //return response.body;
           // return json.decode(response.body);
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

   Future detalle(id) async{
          try{
          var response = await http.get(
              Uri.parse('$_url'+'/api/api/v2/paquete/detalle/'+id.toString()),
            headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer ${sessionUser.token}',
            }
          );
          String jsonsDataString = await response.body.toString();
          int statusCode = response.statusCode;
          if(statusCode==201){
                final jsonData = jsonDecode(jsonsDataString);
                return jsonData;
          }else{
               return null;
          }
        
             
          }catch (e) {
              mySnackbar.show(context, "error"+e.toString());
              return e;
          }          
   }
   Future sugestive() async{
          try{
            var response = await http.get(Uri.parse('$_url/api/carrito/sugestive/CANAL-1012/TI-1500'),);
          String jsonsDataString = await response.body.toString();
          final jsonData = jsonDecode(jsonsDataString);  
                  return jsonData["data"];
          }catch (e) {
                   print('error ES:$e');
                  return null;                
          } 
        
   }
   Future free() async{
          try{
            var response = await http.get(Uri.parse('$_url/api/carrito/free/CANAL-1012/TI-1500'),);
            String jsonsDataString = await response.body.toString();
            final jsonData = jsonDecode(jsonsDataString);  
                  return jsonData["data"];
          }catch (e) {
                  mySnackbar.show(context, "error"+e.toString());
                  return null;                
          } 
        
   }

  
}