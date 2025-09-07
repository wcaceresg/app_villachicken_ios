import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class LoginController{
late BuildContext context;
late BuildContext dialogContext;
TextEditingController emailcontroller=new TextEditingController();
TextEditingController passwordcontroller=new TextEditingController();
final FocusNode emailNodeFocus = FocusNode(); 
final FocusNode passwordNodeFocus = FocusNode(); 
UserProvider userprovider=new UserProvider();
SharedPref _sharedPref=new SharedPref(); 
Future init(BuildContext context) async{
this.context=context;
print("hello");
 // await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;
       try{
          User user=User.fromJson(await _sharedPref.read('user') ?? {});
            if(user?.token!=null){
              //Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);// va eliminar todas las pantallas anteriores
              //Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);// va eliminar todas las pantallas anteriores 
             // Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
              // print('TIENES SESSION GUARDADA');  
            }else{
            // print('NO TIENES SESION GUARDADA');
            }

        } catch (e) {
          //print('Exception data'+e);
        }



}
void login() async{
    String email=emailcontroller.text;
    String password=passwordcontroller.text; 
    _onLoading();
    ResponseApi responseApi=await userprovider.login(email, password);
    Navigator.pop(dialogContext);
    if(responseApi.code==201)
    {
      User user=User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      _sharedPref.save('user-pwd', password);
      //print(user.toJson());
      //Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
      Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
      //print(responseApi.data["user"]);
    }else
    {
      mySnackbar.show(context, responseApi.error);
    }
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
/*
Future<String> login_nativo() async{
    var usuario = emailcontroller.text;
    var password = passwordcontroller.text;
    var nombreUsuario;
    //var url ="https://portal.villachicken.com.pe/api/login";
    try{
        //Uri url = Uri.https("https://portal.villachicken.com.pe", '/api/login');
        //Metodo post
        var response = await http.post(
            Uri.parse('https://portal.villachicken.com.pe/api/login'),
            headers:{ "Accept": "application/json","Content-Type": "application/x-www-form-urlencoded" } ,
            body: { "tipo_login":"0","email": '$usuario',"password": '$password'},
            encoding: Encoding.getByName("utf-8")
        );
        if(response.statusCode==201){
          print(json.decode(response.body)['data']['token']);
        }else{
          //print("credenciales invalidas");
        }

    }catch (e) {
            //print('error ES:$e');
            return null;
    }     
}
*/

}