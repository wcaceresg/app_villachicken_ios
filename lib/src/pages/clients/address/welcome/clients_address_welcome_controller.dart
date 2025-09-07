import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:villachicken/src/api/envioroment.dart';
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
class ClientsAddressWelcomeController{
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
var user;
bool enabled = true;
int selectType=0;
List address_llevar=[];
final ScrollController controller = ScrollController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
TextEditingController addresstextcontroller = new TextEditingController();
GlobalKey<FormState> formkey=new GlobalKey<FormState>();
TextEditingController phonellevarcontroller=new TextEditingController();
final FocusNode phonellevarcontrollerfocus = FocusNode();
int selectLlevarIndex=0;
Future init(BuildContext context,Function refresh) async{
  this.context=context;
  this.refresh=refresh;
  _onLoading();
  initProvider();
  initReloadToken().then((value){
     getAddressProvider();
  }).catchError((error){
    mySnackbar.show(context, Catalogs.error_500);
  }); 
  _sharedPref.remove('order');
  _sharedPref.remove('cobertura');
}
Future initProvider() async{
  try {
    await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;
    await addressprovider.init(context, await _sharedPref.read('user') ?? {});
  } catch (e) {
     print(e);
  }
  
}
Future initReloadToken() async{
    try {
       await userprovider.reload_token();
  } catch (e) {
     print(e);
  }
}
Future getAddressProvider() async{
  user=User.fromJson(await _sharedPref.read('user') ?? {});
  final data=await addressprovider.list(user.token);
  Navigator.pop(dialogContext);
  if(data['code']==400){
         if(data['error'].contains('Nuestro horario')!=false){
            dialog(data['error']);
         }
  }else{
    enabled=false;
    address=data['data'];
  }
   refresh();
}
  void handleRadioValueChange(int value) async{
    radioValue=value;
     _sharedPref.save('address',address[value]);
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
    }).then((value) => {});
    ;

    if(refPoint!=null){
      //refPointController.text=refPoint['address'];
      print(refPoint['address']);
      refresh();
    }

    
  }
  void SelectAdd(index) async{
           //print(address[index]);
          // return;
           AddressSelect=[];
           address[index]["type"]=0; // 0 delivery 1 llevar
           address[index]["type_name"]=Environment.typeDelivey.toString(); 
           AddressSelect.add(address[index]);
          _sharedPref.save('address_select', address[index]);
          // mySnackbar.show(context, 'ADDRESS CREADO CORRECTAMENTE');
          Navigator.pushNamed(context, 'client/main');
  }

  Future dialog(message){
    return showDialog(context: context, 
       barrierDismissible: false,
       builder: (context)=>AlertDialog(
       //title: Text(message),
              content: WillPopScope(
                 onWillPop: () async => false, // False will prevent and true will allow to dismiss
                child: Container(
                  //height: MediaQuery.of(context).size.width*1,
                  height: 300,
                 // decoration: BoxDecoration(color: Colors.red),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left:20,right: 20),
                  child: SingleChildScrollView(
                    //padding: const EdgeInsets.all(8.0),
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
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
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
  void onSubmit(lat,lng) async {
    _onLoading();
    try {
      final res=await addressprovider.validate_cobertura_llevar(lat.toString(),lng.toString());
        Navigator.pop(dialogContext);
        address_llevar=res['data'];
          if(res['success']==true){
          }else{
            mySnackbar.show(context,res['mensaje'] );
          }
    } catch (e) {
       mySnackbar.show(context, Catalogs.error_500);
    }
  }

  void SelectAddRecojo(index) async{
    selectLlevarIndex=index;
          /*final datasend={
            'id':address_llevar[index]['id'],
            'ADD_DIR_DOMICILIO':address_llevar[index]['address'],
            'ADD_ADI_NOMBRE':address_llevar[index]['store'],
            'ADD_DIR_NUMERO':'00',
            'ADD_DIR_REFERENCIA':'',
            'ADD_DIR_DISTRITO':'',
            'ADD_ADI_REFERENCIA':'',
            'ADD_ADI_TELEFONO':'',
            'ADD_DIR_USER_ID':'',
            'ADD_DIR_FLAG':'ACTIVO',
            'created_at':'',
            'updated_at':'',
            'ADD_DIR_SELECTED':'',
            'ADD_LATITUD':address_llevar[index]['latitude'],
            'ADD_LONGITUD':address_llevar[index]['longitude'],
            'ADD_TIENDA_ID':address_llevar[index]['idtienda'],
            'ADD_MERCHANT_ID':address_llevar[index]['merchantid'],
            'type':1,
            'type_name':Environment.typeLLevar.toString()
          };
           _sharedPref.save('address_select', datasend);
           */
          //_onLoading();
          dialogAdress("Ingresa Número de celular");  
          return;
            final res=await addressprovider.Create('TI-1500','12345678',address_llevar[index]['store'],address_llevar[index]['address'],address_llevar[index]['merchantid'],address_llevar[index]['store'],address_llevar[index]['latitude'],address_llevar[index]['longitude'],1,user.token);

            

            Navigator.pop(dialogContext);
          if(res['code']==201){
            // print("exitosamente****************");
             //print(res["data"]);
              //print('ADDRESS CREADO CORRECTAMENTE');
              _sharedPref.save('address_select', res["data"]);
               Navigator.pushNamed(context, 'client/main');
              // mySnackbar.show(context, 'ADDRESS CREADO CORRECTAMENTE');
            

          }else{
              mySnackbar.show(context, res['error']);
          }
          return;

         
  }
   
  Future llevarStore() async{
          _onLoading();
          final res=await addressprovider.Create(
            //'TI-1500',
             address_llevar[selectLlevarIndex]['idtienda'],
            address_llevar[selectLlevarIndex]['merchantid'],
            address_llevar[selectLlevarIndex]['address'],
            'LLEVAR',
            phonellevarcontroller.text,
            address_llevar[selectLlevarIndex]['store'],
            address_llevar[selectLlevarIndex]['latitude'],
            address_llevar[selectLlevarIndex]['longitude'],
            1,
            user.token);
          Navigator.pop(dialogContext);
          if(res['code']==201){
              _sharedPref.save('address_select', res["data"]);
               Navigator.pushNamed(context, 'client/main');
          }else{
              mySnackbar.show(context, res['error']);
          }
  }
  Future dialogAdress(message){
    return showDialog(context: context, 
       barrierDismissible: false,
       builder: (context)=>AlertDialog(
       //title: Text(message),
              content: Container(
                //height: MediaQuery.of(context).size.width*1,
                height: 150,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left:20,right: 20),
                child: SingleChildScrollView(
                  //padding: const EdgeInsets.all(8.0),
                  child: Form(
                     key: formkey,
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              message,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: phonellevarcontroller,
                            focusNode: phonellevarcontrollerfocus,
                            maxLength: 9,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'INGRESE TELEFONO',
                            ),
                            validator: (value) {
                              String pattern = r'^[0-9]{9}$'; // Acepta solo 9 dígitos
                              RegExp regExp = RegExp(pattern);
                              String newValue = value!.replaceAll(RegExp(r"\s+\b|\b\s"), "");
                              if (newValue.isEmpty) {
                                return 'Ingrese el número de teléfono';
                              } else if (!regExp.hasMatch(newValue)) {
                                return 'Solo se permiten 9 dígitos';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                  ),
                ),
              ),

      // content: Text('el texto del cuadro'),
       actions: <Widget>[
        TextButton(onPressed:() {
        if(formkey.currentState!.validate()){
            //documento=boleta_document_controller.text;
             //documento_nombre=boleta_nombre_controller.text;
                  Navigator.of(context).pop('Aceptar');
                  llevarStore();
              }else{
                return;
              }

             //Navigator.of(context).pop('Aceptar');
             //SystemNavigator.pop();
        }, child: Text('Aceptar'))

        
       ],
    ));
  }  
void selectTabMenu()async{
  if(selectType==0){
     _onLoading();
     initReloadToken();
     getAddressProvider();
  }
  if(selectType==1){
    limpiarLlevar();
  }
   refresh();
}
  void updateLocation() async{
    try{
       Position pos= await _determinePosition();// obtener la posicion actual y solicitar los permisos
        onSubmit(pos.latitude,pos.longitude);
    }catch(e){
      mySnackbar.show(context, Catalogs.error_500);
    }
  }
  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
      mySnackbar.show(context, 'Location services are disabled.');
    return Future.error('Location services are disabled.');
   
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    
       mySnackbar.show(context, 'Location permissions are denied.');
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
   
       mySnackbar.show(context, 'Location permissions are permanently denied, we cannot request permissions.');
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  return await Geolocator.getCurrentPosition();
}

void limpiarLlevar() async{
  addresstextcontroller.text='';
  address_llevar=[];
  //refresh();

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