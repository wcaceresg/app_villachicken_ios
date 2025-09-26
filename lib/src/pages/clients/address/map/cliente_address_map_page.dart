

//import 'package:villachicken/src/pages/clients/address/map/clients_address_map_controller.backup';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:villachicken/src/pages/clients/address/map/client_address_map_controller.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({ Key  ? key }) : super(key: key);

  @override
  State<ClientAddressMapPage> createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {

  ClientAddressMapController _con=new ClientAddressMapController();
  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
@override
  Widget build(BuildContext context) {

    
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Container(
        //height:1500,
        child: Scaffold(
           /*appBar: AppBar(
             title:Text('Ubica tu Direccion de mapa'),
             backgroundColor: MyColors.primarycolor,
           ),
           */
           body: Stack(
            
             children: [
             
               _googleMaps(),
               _placeSearch(),
               //_FormSearch(),
               /*Container(
                
                 alignment: Alignment.center,
                   margin: EdgeInsets.only(top: 100),
                child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: Colors.amber[600],
                        child: const Center(child: Text('Entry A')),
                      ),
                      Container(
                        height: 50,
                        color: Colors.amber[500],
                        child: const Center(child: Text('Entry B')),
                      ),
                      Container(
                        height: 50,
                        color: Colors.amber[100],
                        child: const Center(child: Text('Entry C')),
                      ),
                    ],
                  ),
               ),
               */

              //_placeSearch(),
               
              _con.flag_init_page==true?Container(
                 alignment: Alignment.center,
                 child: _IconMyLocation(),
               ):Container(),
               /*Container(
                 margin: EdgeInsets.only(top: 80),
                 alignment: Alignment.topCenter,
                 child: _cardPositionName(),
               ),
               */
               /*Container(
                 margin: EdgeInsets.only(bottom: 100,right: 20),
                 padding: EdgeInsets.all(5),
                 alignment: Alignment.bottomRight,
                 child: _ButtonMyLocation(),
               ),*/               
               Container(
                 alignment: Alignment.bottomCenter,
                 child: _con.addressLatLng!=null?_ButtonAccept():Container(),
               )
               /*Container(
                child:Column(
                  children: [
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          onChanged: (value) => {},
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: "Search your location",
                            /*prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: SvgPicture.asset(
                                "assets/img/icons/location-pin.svg",
                                color: Colors.black,
                              ),
                            )
                            */
                          ),
                        ),
                      ),
                    )
                  ],
                ) ,
               ),*/
               /*Container(
                 alignment: Alignment.center,
                 child: _IconMyLocation(),
               ),
               Container(
                 margin: EdgeInsets.only(top: 30,left: 10),
                 alignment: Alignment.topLeft,
                 child:                       GestureDetector(
                            onTap: (){ Navigator.pop(context);},
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Color(0xFF756d54),
                              ),
                            ),
                          ),
               ),
        
               Container(
                 margin: EdgeInsets.only(top: 80),
                 alignment: Alignment.topCenter,
                 child: _cardPositionName(),
               ),
               Container(
                 alignment: Alignment.bottomCenter,
                 child: _ButtonAccept(),
               )
               */
             ],
           ),
        
           
        
        ),
      ),
    );
  }
  Widget _FormSearch(){
    return Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              ),
              child: Form(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        hintText: "Escribe tu dirección aqui . . .",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        
                        

                    ),
                  ),
                ),
              ),
    );
  }
  Widget _cardPositionName(){
    return Container(
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
         child: Container(
           padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
           child: Text(
             _con.addressName ?? '',
            // 'calle falsa con carrete',
             style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
             ),
            ),
         ),
      ),
    );
  }

  Widget _ButtonAccept(){
    return Container(
      height: 50,
      width:double.infinity,// toda la pantalla
      margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
      child: ElevatedButton(
        onPressed: _con.selectrefPoint,
       //onPressed: () => {},
        child:Text(
          'Siguiente'
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
        
          //primary: MyColors.primarycolor,
          foregroundColor: Colors.white,
          
          //disabledBackgroundColor: MyColors.secondaryColor,
          backgroundColor: MyColors.secondaryColor
        ),
        
      ),
    );
  }
  Widget _ButtonMyLocation(){
    return ElevatedButton(
          onPressed: () {_con.updateLocation();},
          child: Icon(Icons.location_searching_rounded, color: Colors.white),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.black, // <-- Button color
            foregroundColor: Colors.black12, // <-- Splash color
          ),
        );
  }

  Widget _IconMyLocation(){
    return Image.asset(
      'assets/img/villy_location.png',
      width: 100,
      height:100,
      //color: Colors.red,
    );
  }
  Widget _googleMaps(){
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _con.initialPosition,
        onMapCreated: _con.onMapCreated,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled:false,
        onCameraMove: (position){
          _con.initialPosition=position;
        },
        onCameraIdle: ()async{
          await  _con.setLocationDraggableInfo();
        },
      );
  }

  Widget _placeSearch(){
    return Container(
                // margin: EdgeInsets.only(top: 100,left: 10),
      //alignment: Alignment.topCenter,
       margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              ),
      child: Padding(
          padding: const EdgeInsets.all(1),
          child: Form(
            key: _con.formKey,
            autovalidateMode: _con.autovalidateMode,
            child: GooglePlacesAutoCompleteTextFormField(
              textEditingController: _con.addresstextcontroller,
              googleAPIKey: _con.yourGoogleAPIKey,
              style: TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Escribe tu dirección aqui',
                //labelText: 'Address',
                
                //labelStyle: TextStyle(color: Colors.purple),
                //border: OutlineInputBorder(),
                border: InputBorder.none,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                
                
                //color:Colors.black
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              // proxyURL: _yourProxyURL,
              maxLines: 1,
              overlayContainer: (child) => Material(
                elevation: 1.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
              getPlaceDetailWithLatLng: (prediction) {
                _con.onSubmit(prediction.lat,prediction.lng);
              //  print('placeDetails${prediction.lng}');
              //  print('placeDetails${prediction.lat}');
              },
              itmClick: (Prediction prediction) =>{
                  _con.addresstextcontroller.text = prediction.description!,
                  _con.addressName=prediction.description!,_con.flag_init_page=true
              }
          
              
            ),
          ),
        ),
    );
  }


  


  void refresh(){
    setState(() {
      
    });
  }
}