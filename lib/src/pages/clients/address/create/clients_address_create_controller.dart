import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/clients/address/map/cliente_address_map_page.dart';
import 'package:villachicken/src/pages/clients/products/details/ClientsProductsDetailsPage.dart';
import 'package:villachicken/src/providers/address_provider.dart';
import 'package:villachicken/src/providers/carta_provider.dart';
import 'package:villachicken/src/providers/slider_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/catalogs.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientsAddressCreateController{
late Function refresh;
late BuildContext context;
late BuildContext dialogContext;
UserProvider userprovider=new UserProvider();
AddressProvider addressprovider=new AddressProvider();
SharedPref _sharedPref=new SharedPref();
GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();

GlobalKey<FormState> formkey=new GlobalKey<FormState>();
late Map<String,dynamic> refPoint;

int selectalias=0;
//late  Map<String,dynamic> data;
var data;
final ScrollController controller = ScrollController();

TextEditingController addressController=new TextEditingController();
final FocusNode addressNodeFocus = FocusNode();

TextEditingController referenciaController=new TextEditingController();
final FocusNode referenciaNodeFocus = FocusNode();
TextEditingController telefonoController=new TextEditingController();
final FocusNode telefonoNodeFocus = FocusNode();
TextEditingController aliasController=new TextEditingController();
final FocusNode aliasNodeFocus = FocusNode();
late User user;

Future init(BuildContext context,Function refresh) async{
  this.context=context;
  this.refresh=refresh;

  
  try {
  await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;
  await addressprovider.init(context, await _sharedPref.read('user') ?? {});
  } catch (e) {
    
  }


  try {
      data = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic> ; 
  } catch (e) {
    
  }
 
    user=User.fromJson(await _sharedPref.read('user') ?? {});
    //_con.address
    print('xxx');
    print(data);
  refresh();
 
}
  void registrar() async{
    if(formkey.currentState!.validate()){
      String parm_address=data['address'];
      String parm_referencia=referenciaController.text;
      String parm_telefono=telefonoController.text;
      String parm_alias='';
      String lat=data['lat'].toString();
      String lng=data['lng'].toString();
      String id_tienda=data['idtienda'];
      String merchant_id=data['merchant_id'];
      if(selectalias==0){parm_alias='Casa';}
      if(selectalias==1){parm_alias='Trabajo';}
      if(selectalias==2){parm_alias=aliasController.text;}

      print(id_tienda);
       /*print('valido');
        Navigator.pop(dialogContext);
       final res=await addressprovider.Create(id_tienda,merchant_id,parm_address,parm_referencia,parm_telefono,parm_alias,lat,lng,0,user.token);
       if(res['code']==201){
          //print('ADDRESS CREADO CORRECTAMENTE');
          _sharedPref.save('address_select', res["data"]);
          // mySnackbar.show(context, 'ADDRESS CREADO CORRECTAMENTE');
          Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);

       }else{
          mySnackbar.show(context, data['error']);
       }
       */
      _onLoading();
      try {
        final res=await addressprovider.Create(id_tienda,merchant_id,parm_address,parm_referencia,parm_telefono,parm_alias,lat,lng,0,user.token);
        Navigator.pop(dialogContext);
        if(res['code']==201){
            _sharedPref.save('address_select', res["data"]);
            Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
        }else{
            mySnackbar.show(context, data['error']);
        }
      } catch (e) {
            Navigator.pop(dialogContext);
            mySnackbar.show(context, e.toString());
      }
    }else{
         mySnackbar.show(context, "Formulario no valido");
    }
  }
   logout(){
    _sharedPref.logout(context);
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