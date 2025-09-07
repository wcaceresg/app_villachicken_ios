import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/utils/functions.dart';
import 'package:villachicken/src/utils/shared_pref.dart';//basename
class OrderProvider{
   String _url= Environment.API_DELIVERY;
   late BuildContext context;
   late User sessionUser;
   SharedPref _sharedPref= new SharedPref();
   List carrito_sesion=[];
   List address=[];
   Future  init(BuildContext context,User sessionUser) async {
     this.context=context;
     this.sessionUser=sessionUser;
   }
    Future store() async{
      var order_id=0;
      double price=0; 
      int type_comprobante=1;
      double recargo=0;
      var order_resume={};
      if(await _sharedPref.contains('order_resume')){
         order_resume=await _sharedPref.read('order_resume');
      }
      if(await _sharedPref.contains('order')){
            carrito_sesion=await _sharedPref.read('order');
      }
      if(await _sharedPref.contains('address_select')){
        try{
          address.add(await _sharedPref.read('address_select') );
        }catch(e){
        // print(e);
        }
      }
    if(await _sharedPref.contains('cobertura')){
        final obj=await _sharedPref.read('cobertura');
        recargo=obj['recargo'];  
    }


      List Detalle=[];
      int count=0;
      for (var i = 0; i < carrito_sesion.length; i++) {
        // print(carrito_sesion[i]["paq_detalle"]);
          price+=num.parse(carrito_sesion[i]["pu"]).toDouble()*num.parse(carrito_sesion[i]["cantidad"].toString()).toInt();
          Detalle.add({
                      "PAQUE_ID":carrito_sesion[i]["id"],
                      "CANTIDAD":carrito_sesion[i]["cantidad"],
                      "PRECIO":carrito_sesion[i]["pu"],
                      "DESCUENTO":double.parse(carrito_sesion[i]["descuento"].toString()).toStringAsFixed(2),
                      //"DESCUENTO":0,
                      "DESCRIPCION":carrito_sesion[i]["observacion"],
                      "ORDER_COMBINACION_OR" :[]
          });
          for (var j = 0; j < carrito_sesion[i]["paq_detalle"].length; j++) {
                  Detalle[count]["ORDER_COMBINACION_OR"].add({
                              "COMB_ID":int.parse(carrito_sesion[i]["paq_detalle"][j]["comb_id"].toString()),
                              "PROD_ID": int.parse(carrito_sesion[i]["paq_detalle"][j]["prod_id"].toString()),
                              "PRECIO": double.parse(carrito_sesion[i]["paq_detalle"][j]["precio"].toString()),
          });
        }
        count++;                    
      }
      //price=double.parse(price.toStringAsFixed(2));
      //print(price);

      if(order_resume['comprobante']['id']==2){
         type_comprobante=2;
      }
      double descuento=0;
      FunctionsUtil fn=new FunctionsUtil(recargo);
      descuento=fn.getDcto(carrito_sesion);
      price=fn.getTotal(carrito_sesion);

      String tienda_id="TI-1500";
      if(!Environment.isTest){
        tienda_id=address[0]["ADD_TIENDA_ID"];
      }
      final myJson = {
        "ORDER_DEMEMO_OR" :"PEDIDO APP MOVIL",
        "ORDER_OTRTOT_OR" : 0,
        "ORDER_CANBOL_OR" : 0,//bolsas
        "ORDER_REMOTO_IP" : '192.168.1.12',
        "ORDER_TIPCOM_OR" : type_comprobante,
        "ORDER_TIPDOC_OR" : type_comprobante,
        "ORDER_NUMDOC_OR" : order_resume['comprobante']['document'].toString(), 
        "ORDER_NOMCOM_OR" : order_resume['comprobante']['document_name'].toString(),
        "ORDER_ADDCLI_OR" : "LIMA PERU",
        "OPDER_ADDDES_OR" : " "+order_resume['comprobante']['document_address'].toString(),
        //"OPDER_ADDDES_OR" => "".$datos['0']->cliente_direccion, 
        "ORDER_ADDENV_ID":  address[0]["id"].toString(), // DIRECION ID
        //"ORDER_USUARIO_ID" : user_id, // user id
        "ORDER_USUARIO_ID" :sessionUser.user.id,
        //"ORDER_TIENDA_ID" =>$datos['0']->tienda_id, 
        "ORDER_TIENDA_ID" :tienda_id,
        "ORDER_SECUEN_CO" :order_resume['sencuencial'].toString(),// secuencia id
        "ORDER_CANAL_OR" :0, // 1 web 0 app movil
        "ORDER_PAGOCO_OR" :order_resume['efectivo']['payment'], // pago con
        "ORDER_PAGOVU_OR" :order_resume['efectivo']['vuelto'], // vuelto
        "ORDER_DESTOT_OR" :descuento,   // nuevaversion mayo 2022
        "ORDER_DETALL_OR":Detalle,
        "ORDER_TYPE":address[0]["ADD_TYPE"], // type 0 delivery 1 llevar
        "ORDER_RECARGO":recargo, // type 0 delivery 1 llevar
        "ORDER_PAGOS_OR":[
          
            {
                "SECUENCIA_TARJETA_ID" : order_resume['payment_method']['id'], // visa contra entrega 
                //"SECUENCIA_TARJETA_ID" => intval(2), 
                "SECUENCIA_MONEDA_ID" : order_resume['payment_method']['id_money'],
                "TARJETA_NOMBRE" : order_resume['payment_method']['name'].toString(),
                "MONEDA_NOMBRE" : order_resume['payment_method']['money_name'],
                "NUM_OPERACION" : order_resume['payment_method']['operacion'].toString(),
                //"NUM_OPERACION" => "991203179484377",
                "TRANSACTION_ID" : order_resume['payment_method']['transaction_id'].toString(),
                "PAGO_MONTO" : price, 

            }
          
        ],

      };





              try{
              var response = await http.post(
                  Uri.parse('$_url''/api/orders'),
                  headers:{ "Accept": "application/json","Content-Type": "application/json" , 'Authorization': 'Bearer ${sessionUser.token}',} ,
                  body: json.encode(myJson),
                  //encoding: Encoding.getByName("utf-8")
              );
                String jsonsDataString = await response.body.toString();
                final jsonData = jsonDecode(jsonsDataString);
                print('responseeeeeeeeeeeeeeeeeeee backend');
                print(response.statusCode);
                print(jsonData);
           
                return response.statusCode;
                //print(data);
                //return responseApi; 

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
                    // return ResponseApi.fromJson({});

              }          
      }

   Future ListOrders()async{
      var token="";
      if(await _sharedPref.contains('user')){ 
          
            final user=User.fromJson(await _sharedPref.read('user') ?? {});
            token=user.token;
            //print(user.token);
      }
     try{
          var response = await http.get(
              Uri.parse('$_url''/api/api/v1/orders'),
              headers:{"Content-Type": "application/x-www-form-urlencoded" , 'Authorization': 'Bearer ${token}',} ,
             
          );
            String jsonsDataString = await response.body.toString();
            final jsonData = jsonDecode(jsonsDataString);
            //print(jsonData);
            return jsonData;
          }catch (e) {
                  print('error ES:$e');
                 // return ResponseApi.fromJson({});
          }          
   }
  
}