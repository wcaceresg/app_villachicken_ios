import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:path/path.dart';
import 'package:villachicken/src/models/response_api.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/pages/clients/address/map/cliente_address_map_page.dart';
import 'package:villachicken/src/pages/clients/products/details/ClientsProductsDetailsPage.dart';
import 'package:villachicken/src/providers/address_provider.dart';
import 'package:villachicken/src/providers/carta_provider.dart';
import 'package:villachicken/src/providers/slider_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/traits/functions.dart';
import 'package:villachicken/src/utils/my_snackbar.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientsAddressListController{
late Function refresh;
late BuildContext context;
late BuildContext dialogContext;
UserProvider userprovider=new UserProvider();
AddressProvider addressprovider=new AddressProvider();
SharedPref _sharedPref=new SharedPref();
GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();
late Map<String,dynamic> refPoint;
List ok=[];
List address=[];
int radioValue=0;
List AddressSelect=[];
bool enabled = true;
final ScrollController controller = ScrollController();
Future init(BuildContext context,Function refresh) async{
  this.context=context;
  this.refresh=refresh;
  try {
      await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;
  await addressprovider.init(context, await _sharedPref.read('user') ?? {});
  } catch (e) {
    
  }

  //_onLoading();

try {
    await userprovider.reload_token();
} catch (e) {
  
}
  
  
  User user=User.fromJson(await _sharedPref.read('user') ?? {});
  final data=await addressprovider.list(user.token);
  print('direcciones');
  print(data);
  //Navigator.pop(dialogContext);
  if(data['code']==400){
         if(data['error'].contains('Nuestro horario')!=false){
          //mySnackbar.show(context, data['error']);
          //dialog(data['error']);
         }
  }else{
    //enabled=false;
    address=data['data'];
  }
 
  
  /*
  if(await _sharedPref.contains('user')){
    try{
      User user=User.fromJson(await _sharedPref.read('user') ?? {});
      final pwd=await _sharedPref.read('user-pwd');
      final data=await addressprovider.list(user.token);
      if(data['code']==400){
         if(data['error'].contains('Nuestro horario')!=false){
          mySnackbar.show(context, data['error']);
         }else{
          //token relogear
            ResponseApi responseApi=await userprovider.login(user.user.email, pwd);
            if(responseApi.code==201)
            {
              User user=User.fromJson(responseApi.data);
              _sharedPref.save('user', user.toJson());
              //print(user.toJson());
              final data=await addressprovider.list(user.token);
              address=data['data'];
              //Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
              //print(responseApi.data["user"]);
              print('relogear');
            }else
            {
               print('no');
               Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
             // mySnackbar.show(context, responseApi.error);
            }
         }

      }else{
           address=data['data'];
           print(address);
           print('paso 2');
      }
       print('paso 3');
      //print(data['code']);
      // Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
    }catch(e){
      mySnackbar.show(context, e);
      print('errorr');
     //  Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }

  }
  */

  //await userprovider.reload_token();


  //slider=await sliderprovider.list();
  //slider=new Map<String, dynamic>.from(await sliderprovider.list());
  //carta=new Map<String, dynamic>.from(await cartaProvider.ListPromociones());
 // ResponseApi responseApi=await cartaProvider.ListPromociones();
  //List<String> carta = List<String>.from(await cartaProvider.ListPromociones());
  //carta=await cartaProvider.ListPromociones();
   //ResponseApi responseApi=await cartaProvider.ListPromociones();
   //print(responseApi);
   //final ok=await cartaProvider.ListPromociones();
   //final d=json.decode(json.encode(ok));
   //print(d["data"][0]);
  // print(carta["data"][0]);

  //print('okk');
 // refresh();
 setTimeout(()=>{enabled=false,refresh()},1000);
}
   void handleRadioValueChange(int value) async{
    radioValue=value;
     _sharedPref.save('address',address[value]);

    //print(value);

    //Address a=Address.fromJson(await _sharedPref.read('address') ?? {});
    //print('se guardo la direccion: ${a.toJson()}');
    refresh();
    print('VALOR SELECCIONADO : $radioValue');
  }

  void openMap() async{
    refPoint=await showModalBottomSheet(
    context: context, 
    isDismissible: false,
    enableDrag: false,
     isScrollControlled: true,
    builder: (context)=>ClientAddressMapPage())
    .whenComplete(() {
    // print('Hey there, I\'m calling after hide bottomSheet*************************************************************************************************************************');
    }).then((value) => {});;

    if(refPoint!=null){
      //refPointController.text=refPoint['address'];
      print(refPoint['address']);
      refresh();
    }
  }
  void SelectAdd(index) async{
           AddressSelect=[];
           AddressSelect.add(address[index]);
           print(AddressSelect);
          _sharedPref.save('address_select', address[index]);
          // mySnackbar.show(context, 'ADDRESS CREADO CORRECTAMENTE');
          Navigator.pushNamed(context, 'client/main');
  }

  Future dialog(message){
    return showDialog(context: context, 
       barrierDismissible: false,
       builder: (context)=>AlertDialog(
       //title: Text(message),
              content: Container(
                //height: MediaQuery.of(context).size.width*1,
                height: 300,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left:20,right: 20),
                child: Column(
                    //alignment: Alignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/img/billy-failed.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Container(
                        //padding: EdgeInsets.only(left:20,right: 20),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),

      // content: Text('el texto del cuadro'),
       actions: <Widget>[
        TextButton(onPressed:() {
             //Navigator.of(context).pop('Aceptar');
             SystemNavigator.pop();
        }, child: Text('Aceptar'))

        
       ],
    ));
  }

  void openDrawer(){
     key.currentState?.openDrawer();
     print("abierto");
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
   logout(){
    _sharedPref.logout(context);
  }



 


}