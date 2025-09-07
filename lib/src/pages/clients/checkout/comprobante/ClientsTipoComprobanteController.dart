
import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/client_provider.dart';
import 'package:villachicken/src/traits/functions.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';

import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientsTipoComprobanteController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 int counter=1;
 SharedPref _sharedPref=new SharedPref();
 ClientProvider clientProvider=new ClientProvider();
 List tipo_comprobante=[];
 int  tipo_comprobante_select=0;
TextEditingController boleta_document_controller=new TextEditingController();
final FocusNode boletaDocumentNodeFocus = FocusNode();
TextEditingController boleta_nombre_controller=new TextEditingController();
final FocusNode boletaNombreNodeFocus = FocusNode();
TextEditingController factura_document_controller=new TextEditingController();
final FocusNode FacturaDocumentNodeFocus = FocusNode();
TextEditingController factura_nombre_controller=new TextEditingController();
final FocusNode FacturaNombreNodeFocus = FocusNode();
TextEditingController factura_address_controller=new TextEditingController();
final FocusNode FacturaAddressNodeFocus = FocusNode();
GlobalKey<FormState> formkey=new GlobalKey<FormState>();
GlobalKey<FormState> formkeyFactura=new GlobalKey<FormState>();

late var client;
Future init(BuildContext context,Function refresh,data) async{
  this.context=context;
   this.refresh=refresh;
  // this.selectedProducts.add(data);
 //print(data);
 tipo_comprobante=data["tipo_comprobante"];
 tipo_comprobante_select=data['tipo_comprobante_select'];
 boleta_document_controller.text=data['documento'];
 boleta_nombre_controller.text=data['documento_name'];
// print(tipo_comprobante);
initFavoritesProvider();
  refresh();

}
Future initFavoritesProvider() async{
  try {await clientProvider.init(context,  User.fromJson(await _sharedPref.read('user') ?? {}));
  } catch (e) { print(e);
  }
}

Future searchClient() async{
  String documento="";
  if(tipo_comprobante_select==1)
  {
     documento=boleta_document_controller.text;
  }else{
     documento=factura_document_controller.text;
  }
   _onLoading();
  try 
  {     
         await clientProvider.search(documento).then((value) => {
         
          client=value,
          setClient(),
          // favorites=value,
           Navigator.pop(dialogContext),
          // enabled=true,
          refresh()
           
         });
         
  } catch (e) {
        Navigator.pop(dialogContext);
         mySnackbar.show(context, "ERROR INTERNO");
  }

}
void setClient(){
  limpiar();
  if(tipo_comprobante_select==1)
  {
    
     boleta_nombre_controller.text=client['name'];
  }else{

    factura_nombre_controller.text=client['name'];
    factura_address_controller.text=client['address'];
  }
}
void limpiar(){
   //boleta_document_controller.text='';
   boleta_nombre_controller.text='';
   //factura_document_controller.text='';
   factura_nombre_controller.text='';
   factura_address_controller.text='';
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

void register(){
     close_page();
     return;
    if(formkey.currentState!.validate()){
      

       print('valido');
    }else{
      print ('no valido');
    }
}
void typeDocumentChange(){
  print(tipo_comprobante_select);
  if(tipo_comprobante_select==0){

  }
  else if(tipo_comprobante_select==1){
    boleta_document_controller.text='';
    boleta_nombre_controller.text='';
    boletaDocumentNodeFocus.requestFocus();
  }else{
    factura_document_controller.text='';  
    factura_nombre_controller.text='';
    factura_address_controller.text='';
    FacturaDocumentNodeFocus.requestFocus();
  }
  refresh();
}
 void close_page(){
    var name='';
    var documento='77777777';
    var documento_nombre='VARIOS';
    var documento_address='';
    for (var i = 0; i < tipo_comprobante.length; i++) {
          if(tipo_comprobante[i]['id']==tipo_comprobante_select){
              name=tipo_comprobante[i]['ENT_NOMBRE'];
          }
    }

  if(tipo_comprobante_select==1){
    if(formkey.currentState!.validate()){
        documento=boleta_document_controller.text;
        documento_nombre=boleta_nombre_controller.text;

    }else{
      return;
    }
  }
   if(tipo_comprobante_select==2){
    if(formkeyFactura.currentState!.validate()){
            documento=factura_document_controller.text;
            documento_nombre=factura_nombre_controller.text;
            documento_address=factura_address_controller.text;

    }else{
      return;
    }
  } 


      var datos={
          'tipo_comprobante':tipo_comprobante_select,
          'name':name,
          'documento':documento,
          'documento_nombre':documento_nombre,
          'documento_address':documento_address,
      };
      //Navigator.pop(context);
      Navigator.pop(context,datos);



  

 }

}