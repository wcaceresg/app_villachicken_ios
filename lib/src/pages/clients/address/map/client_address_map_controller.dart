import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart' as location;
import 'package:villachicken/src/providers/address_provider.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';
class ClientAddressMapController{
  late BuildContext context;
  late BuildContext dialogContext;
  late Function refresh;
  
  var addressName;
  //LatLng addressLatLng = LatLng(); //by initializing it.
  late LatLng addressLatLng;
  AddressProvider addressprovider=new AddressProvider();
  CameraPosition initialPosition=CameraPosition(
    //target: LatLng(-12.1056334,-76.9686237),
    target: LatLng(-12.058013, -77.041482),
    zoom: 11

  );
  var flag_init_page=false;
  
  Completer<GoogleMapController> _mapController=Completer();
  late Position _position;
  SharedPref _sharedPref=new SharedPref(); 

  //PLACE API
    TextEditingController addresstextcontroller = new TextEditingController();
  final yourGoogleAPIKey = 'AIzaSyDVRr4POPge-guRp0I93afT7bD-jywB0WM';
  // only needed if you build for the web
  final yourProxyURL = 'https://your-proxy.com/';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  Future init(BuildContext context,Function refresh) async{
    this.context=context;
    this.refresh=refresh;
    try {
          await addressprovider.init(context,  await _sharedPref.read('user') ?? {});
    } catch (e) {
      
    }
    
    this.addressName="";

   //updateLocation();
    //checkGPS();
  }

  void onSubmit(lat,lng) async {
   /* if (!formKey.currentState!.validate()) {
      autovalidateMode = AutovalidateMode.always;
    }
    */
    print('lat: ${lat}');
    print('long : ${lng}}');
    print(addresstextcontroller.text);
    try {
        animateCameraToPosition(double.parse(lat),double.parse(lng));
    } catch (e) {
       print('error'+e.toString());
    }


   // refresh();
  }
 
  void selectrefPoint() async{

    Map<String,dynamic> data ={
      'address':addressName,
      'lat':addressLatLng.latitude,
      'lng':addressLatLng.longitude
    };
   // print(addressLatLng.latitude);
   // print(addressLatLng.latitude.toString());
    _onLoading();
    final res=await addressprovider.validate_cobertura(addressLatLng.latitude.toString(),addressLatLng.longitude.toString());
    Navigator.pop(dialogContext);
    if(res['success']==true){
      
      //print('valido');
          Map<String,dynamic> data ={
      'address':addressName,
      'lat':addressLatLng.latitude,
      'lng':addressLatLng.longitude,
      'merchant_id':res['merchantid'],
      'idtienda':res['idtienda'],
      'recargo':res['recargo'],
    };
    _sharedPref.save('cobertura', data);
      Navigator.of(context).pushNamed('client/address/create', arguments: data);
    }else{

    Map<String,dynamic> data ={
      'address':addressName,
      'lat':addressLatLng.latitude,
      'lng':addressLatLng.longitude,
      'merchant_id':'1234',
      'idtienda':'TI-1500',
      'recargo':0,
    };
    _sharedPref.save('cobertura', data);

      //Navigator.of(context).pushNamed('client/address/create', arguments: data);
       dialog(res['mensaje']);
    }
   // return;
    //Navigator.pop(context,data);
    //Navigator.of(context).pushNamed('client/address/create', arguments: data);


    
  }

    Future dialog(message){
    return showDialog(context: context, 
       barrierDismissible: false,
       builder: (context)=>AlertDialog(
       title: Text(message),
      // content: Text('el texto del cuadro'),
       actions: <Widget>[
        TextButton(onPressed:() {
             Navigator.of(context).pop('Aceptar');
        }, child: Text('Aceptar'))

        
       ],
    ));
  }
  Future<Null> setLocationDraggableInfo() async{
    if(flag_init_page==false){
      //print('holaaaaa');
      return;
    }
    if(initialPosition!=null && flag_init_page==true){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;
      print("latitud");
      print (lat);
      print("longitud");
      print (lng);

      try {
       List<Placemark> address=await placemarkFromCoordinates(lat,lng);
      print("address api 1 ");
      //print (address);

      if(address!=null){
          print("address api 2");
        if(address.length>0){
            print("address api 3");
           // print(address);
          String direction=address[0].thoroughfare!;
          String street=address[0].subThoroughfare!;
          String city=address[0].locality!;
          String department=address[0].administrativeArea!;
          String country=address[0].country!;
          addressName='$direction $street, $city, $department';
          addresstextcontroller.text='$direction $street, $city, $department';
           print(addressName);
          addressLatLng=new LatLng(lat, lng);
          refresh();
        }
      }       
      } catch (e) {
        print(e);
      }

      
      

    }
  }

  
  void onMapCreated(GoogleMapController controller){
    //controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }
  void updateLocation() async{
    try{
       Position pos= await _determinePosition();// obtener la posicion actual y solicitar los permisos
      // _position=await Geolocator.getLastKnownPosition() ; // lat y lng
      flag_init_page=true;
     print('latitude');
     print(pos.latitude);
     print(pos.longitude);
      // animateCameraToPosition(_position.latitude,_position.longitude);
      animateCameraToPosition(pos.latitude,pos.longitude);
      // print('hola');
    }catch(e){
      print('error'+e.toString());
    }
  }
  /*
  void checkGPS() async{
    bool isLocationEnabled=await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled){
      updateLocation();
    }else{
      // preguntar al usuario  para activar el gsp
      bool locationGPS=await  location.Location().requestService();
      if(locationGPS){
        updateLocation();
      }
    }
  }
  */
  Future animateCameraToPosition(double lat,double lng) async{
    GoogleMapController controller=await _mapController.future;
    if(controller !=null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:LatLng(lat,lng),
          //zoom:17,
          zoom: 18,
          bearing: 0
        )
      ));
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
     print('Location services are disabled.');
    return Future.error('Location services are disabled.');
   
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
       print('Location permissions are denied.');
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
     print('Location permissions are permanently denied, we cannot request permissions.');
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
   print('Success');
  return await Geolocator.getCurrentPosition();
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