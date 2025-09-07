import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';//basename
class AddressProvider{
   String _url= Environment.API_DELIVERY;
   String _api='/api/address';
   String _cordinates='https://portal.villachicken.com.pe/ol-ti-services/services/villachicken?callback=';
   late BuildContext context;
   //String token;
   late User sessionUser;
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     //this.token=token;
     this.sessionUser=sessionUser;
   }
   Future list(token) async{
          try{
          /*var response = await http.get(
              Uri.parse('$_url$_api'),

          );
          */

    var response = await http.get(Uri.parse('$_url$_api'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //print(json.decode(response.body));
            print("responseee");
             print(response.body);
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

   Future validate_cobertura(String lat,String long) async{
      
          try{
          var response = await http.get(
              Uri.parse(_cordinates+'initMap&&x='+lat.toString()+'&&y='+long.toString()+''),

          );
            //print(response.body);
            return json.decode(response.body);
          }catch (e) {
                  print('error ES:$e');
                  return null;
          }          
   }

   Future validate_cobertura_llevar(String lat,String long) async{
          try{
          var response = await http.get(
              Uri.parse(_cordinates+'llevar&&x='+lat.toString()+'&&y='+long.toString()+''),

          );
            return json.decode(response.body);
          }catch (e) {
                  print('error ES:$e');
                  return null;
          }          
   }


   Future Create(String idtienda,String merchant,String address,String referencia,String telefono,String alias,String lat,String long,int type,String token) async{
          try{
          var response = await http.post(
              Uri.parse('$_url$_api'),
              headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded", 'Authorization': 'Bearer $token', } ,
              body: { "ADD_DIR_DOMICILIO":address,
                      "ADD_DIR_NUMERO": "00",
                      "ADD_DIR_REFERENCIA": referencia,
                      "ADD_DIR_DISTRITO":"Distrito",
                      "ADD_ADI_REFERENCIA":"Aplicacion-movil",
                      "ADD_ADI_TELEFONO":telefono,
                      "ADD_ADI_NOMBRE":alias,
                      "ADD_DIR_SELECTED":"0",
                      "ADD_LATITUD":lat,
                      "ADD_LONGITUD":long,
                      "ADD_TIENDA_ID":idtienda,
                      "ADD_MERCHANT_ID":merchant,
                      "ADD_TYPE":type.toString()
                      },
              encoding: Encoding.getByName("utf-8")
          );
          print(response.body);
           return json.decode(response.body);
          return;
          if(response.statusCode==201){
            final data=json.decode(response.body);
            //print(data);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }else{
            final data=json.decode(response.body);
             ResponseApi responseApi= ResponseApi.fromJson(data);
             return responseApi; 
          }
          }catch (e) {
                  print('error ES:$e');
                  return null;
          }          
   }

  
}