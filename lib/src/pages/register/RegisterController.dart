import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/clients/documents/TypeDocumentPage.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/document_legal.dart';
import 'package:villachicken/src/widgets/loader.dart';
class RegisterController{
late Function refresh;
late BuildContext context;
late BuildContext dialogContext;
TextEditingController emailcontroller=new TextEditingController();
TextEditingController documentocontroller=new TextEditingController();
TextEditingController nombrecontroller=new TextEditingController();
TextEditingController apellidocontroller=new TextEditingController();
int currentSelectedValue=0;
TextEditingController dateinput = TextEditingController();
TextEditingController passwordcontroller=new TextEditingController();
TextEditingController confirmcontroller=new TextEditingController();

final FocusNode emailNodeFocus = FocusNode();
final FocusNode documentNodeFocus = FocusNode();
final FocusNode nombreNodeFocus = FocusNode();
final FocusNode apellidoNodeFocus = FocusNode();
final FocusNode passwordNodeFocus = FocusNode();
final FocusNode confirmNodeFocus = FocusNode();
final FocusNode dateNodeFocus = FocusNode();

var pickedDate;
List currencies=[];
UserProvider userprovider=new UserProvider();
SharedPref _sharedPref=new SharedPref(); 
bool checkvalue=false;
Future init(BuildContext context,Function refresh) async{
  this.context=context;
  this.refresh=refresh;
currencies=[
    {
      "id": 1,
      "name": "Masculino"
    },
    {
      "id": 2,
      "name": "Femenino"
    },
    {
      "id": 3,
      "name": "Otros"
    },

  ];
  currentSelectedValue=currencies[0]["id"];
refresh();

}
void seleccionar_fecha() async{
                   pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950), 
                      lastDate: DateTime(2101)
                  );
                  if(pickedDate != null ){
                      print("obteniendo fecha valor********************************************");
                      //DateTime fecha = DateTime.parse("2024-10-16 00:00:00.000");
                      String formatoDeseado = DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formatoDeseado);  // Salida: 2024-10-16
                     // String formattedDate = Datef('yyyy-MM-dd').format(pickedDate); 
                     // print(formattedDate); 
                         dateinput.text = formatoDeseado; 
                  }else{
                      print("Date is not selected*****************************************");
                  }

}
void registrar() async{
    String email=emailcontroller.text;
    String nombre=nombrecontroller.text;
    String documento=documentocontroller.text;
    String apellido=apellidocontroller.text;
    String contrasenia=passwordcontroller.text;
    String confirm_contrasenia=confirmcontroller.text;
    String fecha=dateinput.text;
  if (email.isEmpty || nombre.isEmpty || apellido.isEmpty   || contrasenia.isEmpty || confirm_contrasenia.isEmpty){
      mySnackbar.show(context, 'No se permiten campos vacios');
      print('invalido:' );
      return;
    }
    if(confirm_contrasenia !=contrasenia){
      mySnackbar.show(context, 'las contrasenias no coinciden');
      print('las contrasenias no coinciden' );
      return;
    }
    if(fecha ==""){
      mySnackbar.show(context, 'Seleccione su fecha de nacimiento');
      return;
    }
    if(checkvalue==false){
      mySnackbar.show(context, 'Debe aceptar los términos y condiciones');
      return;      
    }
        //print('respuesta:${responseApi.toJson()}');
        print('Email: $email');
        print('Documento: $documento');
        print('Nombre: $nombre');
        print('Apelllido: $apellido');
        print('Fecha: $fecha');
        print('Genero: $currentSelectedValue');
        print('Password: $contrasenia');
        print('Confirm: $confirm_contrasenia');
     
        
        _onLoading();
         try {
           ResponseApi responseApi=await userprovider.create(email,nombre,documento,apellido,contrasenia,fecha,currentSelectedValue.toString());
            Navigator.pop(dialogContext);
            if(responseApi.error!=''){
                  var response_error="";
                  for (String error in responseApi.error) {
                      response_error=response_error+","+ error;
                    }
                  mySnackbar.show(context, response_error.toString());
                  return; 
              
            }else{
                   if(responseApi.code==201)
                   {
                        User user=User.fromJson(responseApi.data);
                        _sharedPref.save('user', user.toJson());
                        _sharedPref.save('user-pwd', contrasenia);
                        Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
                   }
            }          
         } catch (e) {
            mySnackbar.show(context, Catalogs.error_500);
         }       
}
void AbrirModal(){
   documentLegalWidget.show(
          context: context,
          child:  TypeDocumentPage(arguments: 1,),
          onComplete: () {
          },
          ondata: (data){
           if(data!=null){
             checkvalue=data['status'];
             refresh();
           }
          }
    );                              
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
}