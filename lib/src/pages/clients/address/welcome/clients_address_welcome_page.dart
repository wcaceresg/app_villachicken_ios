
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/pages/clients/address/welcome/clients_address_welcome_controller.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:villachicken/src/widgets/address_list.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/no_data_widget.dart';
import 'package:villachicken/src/widgets/small_text.dart';
class ClientsAddressWelcomePage extends StatefulWidget {
  const ClientsAddressWelcomePage({ Key ? key }) : super(key: key);

  @override
  State<ClientsAddressWelcomePage> createState() => _ClientsAddressWelcomePageState();
}

class _ClientsAddressWelcomePageState extends State<ClientsAddressWelcomePage>  with TickerProviderStateMixin {
  ClientsAddressWelcomeController _con= new ClientsAddressWelcomeController();
  int select=0;
  int select_llevar=0;
  late TabController _tabController;
int _tab = 0;
@override
dispose() {
  _tabController.dispose(); // you need this
  super.dispose();
}
  
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
       //  _tabController = TabController(vsync:  SingleTickerProviderStateMixin, length: 2);
         _tabController = TabController(
        vsync: this,
        length: 2,
        initialIndex: 0,
      );

    _tabController.animateTo(_con.selectType);

      // _tabController = TabController(vsync: this,length: 2);
      _tabController.addListener(() {

    if (_tabController.indexIsChanging){
          print('ontap');
          print("${_tabController.index}"); 
        
    }
      else if(_tabController.index != _tabController.previousIndex)
            // Tab Changed swiping to a new tab
            //onTabDrag();
            print('drag');
              _con.selectType=_tabController.index;
            if(_con.selectType != _tabController.animation!.value.round()){
            }

                    

      });      
      //print('inica primer init');
      //imageCache.clear();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
        
        _con.init(context,refresh);
       
        
       // imageCache.clear();
      });
    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
           body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
               colors: [
               // Colors.red.shade800.withOpacity(0.9),
              //  Colors.red.shade300
                MyColors.secondaryColor.withOpacity(0.9),
                MyColors.secondaryColor.withOpacity(0.9)
               ],
               begin: const FractionalOffset(0.0, 0.4),
               end: Alignment.topRight
              )
            ),
            child: Column(
              children: [
                Container(
                  //padding:EdgeInsets.only(top:20,left:30,right: 30),
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                  width:MediaQuery.of(context).size.width ,
                  height:300,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                       SizedBox(height: 40,),
                        _buildHeader(),
                        SizedBox(height: 20,),
                        TabsMenu(),   
                    ],
                  ),
                )
                ,
                _buildBody()
    
    
    
                
              ],
            ),
           ),
    );
  }
  Widget _buildHeader(){
    return       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              /*Container(
                               width: 75,
                               height: 149,
                               margin: EdgeInsets.only(right:15),
                                child: Image(image:  AssetImage('assets/img/villy_hello.png'),/*color: Colors.white,*/)
                              ),
                              */
                               /*Container(
                               width: 75,
                               height: 149,
                               margin: EdgeInsets.only(right:15),
                                //child: Image(image:  AssetImage('assets/img/villy_hello.png'),/*color: Colors.white,*/)
                              ),
                              */

                              Center(
                                //padding: EdgeInsets.all(0),
                                child: Column(

                                  children: [
                                    BigText(text: '! Bienvenido ',color: MyColors.homepagemainsmalltext,size: 25,),
                                    SizedBox(height: 5,),
                                    BigText(text: _con.user!=null?_con.user.user.nombres+' !':'',color: MyColors.homepagemainsmalltext,size: 25),                                   
                                  ],
                                ),
                              ),
                          ],
                         );
  }
  Widget  _buildBody() {
  return Expanded(
                   child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: MyColors.fondocolor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      )
                    ),
                    child: TabBarView(
                       controller: _tabController,
                      children: [
                             Step_Delivery(),
                             Step_Recojo()
                      ]
                    ),      
                   ),
                  );

  }



  Widget Step_Delivery(){
   return                      Container(
                      //height: 100,
                         
                      child: Column(
                        children: [
                        
                         SizedBox(height: 15,),
                          title(),
                          MyLocationWidget(),
                         
      
      
                          //SizedBox(height: 30,),
                          //Text('sdasd'),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                   _listAddress()
                                ],
                              ),
                            ),
                          ),
                          //title(),
                          //MyLocationWidget(),
                          //_listAddress()
                        ],
                      ),
                    ); 

  }
  Widget Step_Recojo(){
   return                      Container(
                      //height: 100,
                         
                      child: Column(
                        children: [
                        
                         SizedBox(height: 15,),
                         // title(),
                          _placeSearch(),
                           SizedBox(height: 10,),
                          MyLocationWidget_recojo(),
                         

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                   _listStoreByLocation()
                                ],
                              ),
                            ),
                          ),
                          //title(),
                          //MyLocationWidget(),
                          //_listAddress()
                        ],
                      ),
                    ); 

  }
  Widget TabsMenu(){
    return                TabBar(
      controller: _tabController,
                          tabAlignment: TabAlignment.center,
                          labelPadding: EdgeInsets.only(right: 5),
                          dividerColor: Colors.transparent,
                          onTap: (selectedIndex){
                            //print(selectedIndex);
                            _con.selectType=selectedIndex;
                            _con.selectTabMenu();
                            refresh();
                            //_con.scrollDown(selectedIndex);
                          },
                          
                          //indicatorColor: MyColors.primarycolor,
                          indicatorColor: Colors.white.withOpacity(0),
                          //labelColor: Colors.black,
                         // unselectedLabelColor: Colors.grey[400],
                          isScrollable: true,
                     
                   // isScrollable: true,

                    tabs: [
                      Tab(child:  badge_rounded('PIDE','DELIVERY','assets/img/villa_moto.png',0),height: 120,),
                      Tab(child:  badge_rounded('RECOGE','EN TIENDA','assets/img/villa_home.png',1),height: 120,),
                    

                    ],
                  );
  }

 Widget badge_rounded(String title,String subtitle,String image,int index){
  return                              Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(right:15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: _con.selectType==index?Border.all(
                                  color:MyColors.yellowcolor,
                                  width: 5,
                                ):Border(),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5,),
                                  //Container(margin: EdgeInsets.only(),padding: EdgeInsets.all(0),child: Text(title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                                  Container(margin: EdgeInsets.only(),padding: EdgeInsets.all(0),child: BigText(text: title,size: 12,fontFamily: 'Robotos',)),
                                  //Container(margin: EdgeInsets.only(),child: Text(subtitle,style: TextStyle(fontSize: 12),)),
                                  Container(margin: EdgeInsets.only(),padding: EdgeInsets.all(0),child: BigText(text: subtitle,size: 12,fontFamily: 'Robotos')),
                                  Container( width: 60,height: 60,child: Image(image:  AssetImage(image),/*color: Colors.white,*/))
                                ],
                              )
                            );
 }
 Widget title(){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    
    //height: 50,
    decoration: BoxDecoration(
        
        //color:  Colors.white,
       /* boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        */
    ),  
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: BigText(
              text:'ELIGE TU UBICACION',
             //  color:Colors.black87,      
             //
                
             size: 22,
          ),
      ),
    ),

  );
 }
Widget MyLocationWidget(){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
    
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:  Colors.white,
       /* boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        */
    ),  
    child: InkWell(
      onTap: (){
        /*setState(() {
           //select=index;
           //print(select);
        });
        */
        _con.openMap();
      },  
      child: Row(   
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            width: 30,
            child: Icon(
              //Icons.my_location_sharp,
              Icons.add,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
             //margin: EdgeInsets.only(bottom: 5),
              child: BigText(
               text:'Nueva Dirección',
              //color: Colors.black54,
              size: 12,       
              color:  Colors.black87,
              textAlign: TextAlign.center,
              fontFamily: 'Robotos'
              ),
            ),
          )
        ],
      ),
      /*shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10)      
      ),
      borderSide: BorderSide(color: Colors.white),
      */
    ),
  );
 }
Widget MyLocationWidget_recojo(){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:  Colors.white,

    ),  
    child: InkWell(
      onTap: (){
       
        _con.updateLocation();
      },  
      child: Row(   
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            width: 30,
            child: Icon(
              //Icons.my_location_sharp,
              Icons.location_on,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
             //margin: EdgeInsets.only(bottom: 5),
              child: Text(
               'Usar ubicación Actual',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                       fontFamily: 'Robotos',
                       //color: Colors.black54,
                       fontSize: 12,
                       fontWeight: FontWeight.w500,
                       color:  Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      /*shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10)      
      ),
      borderSide: BorderSide(color: Colors.white),
      */
    ),
  );
 }
Widget _placeSearch(){
    return Container(
      // margin: EdgeInsets.only(top: 100,left: 10),
      //alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              
              ),
      child: Padding(
          padding: const EdgeInsets.all(1),
          child: Form(
            key: _con.formKey,
            autovalidateMode: _con.autovalidateMode,
            child: GooglePlacesAutoCompleteTextFormField(
              textEditingController: _con.addresstextcontroller,
              googleAPIKey: Environment.GOOGLE_API_KEY,
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
                print('GET_PLACE_DETAILS_WITH_LANG');
                //print(prediction);
                _con.onSubmit(prediction.lat,prediction.lng);
              //  print('placeDetails${prediction.lng}');
              //  print('placeDetails${prediction.lat}');
              },
              itmClick: (Prediction prediction){
                print('PREDICTION');
                print(prediction);
                  _con.addresstextcontroller.text = prediction.description!;
                //  _con.addressName=prediction.description!,_con.flag_init_page=true
              }    
            ),
          ),
        ),
    );
  }

Widget _listAddress(){

  return AddressListWidget(
  enabled: _con.enabled,
  addressList: _con.address,
  selectedIndex: select,
  onSelect: (int index) {
    setState(() {
      select = index;
      _con.SelectAdd(index);
    });
  },
);


   return 
                   Skeletonizer(
                     enabled: _con.enabled,
                     child: Container(
                       child: ListView.builder(
                             physics: NeverScrollableScrollPhysics(),/* importante */
                             shrinkWrap: true,
                     
                            //padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                     
                            itemCount: _con.address!=null ? _con.address.length : 0,
                            itemBuilder: (_, index){
                              //print(index);
                              //return _radioSelectorAddress(_con.address[index],index);
                              return customRadioREST(_con.address[index],index);
                              
                             //return Text('222');
                            }
                          ),
                     ),
                   );
  }
  Widget customRadioREST(address,int index){
  return GestureDetector(
      onTap: (){
        setState(() {
           select=index;
           _con.SelectAdd(index);
        });
      },  
    child: Container(
      width: double.infinity, 
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: select==index? MyColors.secondaryColor: Colors.white,
         /* boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          */
          
      ),  
      child: Row(   
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            width: 30,
            child: Icon(
              Icons.location_on_sharp,
              color:select==index? MyColors.yellowcolor: Colors.black,
            ),
          ),
          Expanded(
            //padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(               
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    margin: EdgeInsets.only(bottom: 5),
                     child: Text(
                      _con.address[index]['ADD_ADI_NOMBRE'],
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                              fontFamily: 'Robotos',
                              //color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: select==index? Colors.white: Colors.black
                       ),
                     ),
                   ),
      
                   Container(
                     height: 30,
                   
                     child: Text(
                       _con.address[index]['ADD_DIR_DOMICILIO']+'-'+_con.address[index]['ADD_DIR_REFERENCIA'],
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                                    fontFamily: 'Robotos',
                                    color:select==index? Colors.white: Color(0xFFccc7c5),
                                    fontSize: 12,
                                    height: 1.2
                                           
                       ),
                     ),
                   ),
                   Container(
                      margin: EdgeInsets.only(bottom: 2),
                     child: Text(
                       _con.address[index]['ADD_ADI_TELEFONO'],
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                                    fontFamily: 'Robotos',
                                    color:select==index? Colors.white: Color(0xFFccc7c5),
                                    fontSize: 12,
                                    height: 1.2
                        
                       ),
                     ),
                   ),
      
                ],
              ),
            ),
          ),
          
        ],
      ),
    ),
  );
 }



Widget _listStoreByLocation(){

   return 
                   Skeletonizer(
                     enabled: _con.enabled,
                     child: Container(
                       child: _con.address_llevar.isEmpty ? NoDataWidget(path: 'assets/img/villy_not_recojo.png',text: 'No tienes direccion',) : ListView.builder(
                             physics: NeverScrollableScrollPhysics(),/* importante */
                             shrinkWrap: true,
                     
                            //padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                     
                            itemCount: _con.address_llevar!=null ? _con.address_llevar.length : 0,
                            itemBuilder: (context, index){
                              //print(index);
                              //return _radioSelectorAddress(_con.address[index],index);
                              return customRadioRecojo(index);
                              
                             //return Text('222');
                            }
                          ),
                     ),
                   );
  }
  Widget customRadioRecojo(int index){
  return GestureDetector(
      onTap: (){
        setState(() {
           select_llevar=index;
           _con.SelectAddRecojo(index);
        });
      },  
    child: Container(
      width: double.infinity, 
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: select_llevar==index? MyColors.secondaryColor: Colors.white,
         /* boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          */
          
      ),  
      child: Row(   
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            width: 30,
            child: Icon(
              Icons.home_filled,
              color:select_llevar==index? MyColors.yellowcolor: Colors.black,
            ),
          ),
          Expanded(
            //padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(               
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    margin: EdgeInsets.only(bottom: 5),
                     child: Text(
                      _con.address_llevar.length>0?_con.address_llevar[index]['store']:'',
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                              fontFamily: 'Subway',
                              //color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: select_llevar==index? Colors.white: Colors.black
                       ),
                     ),
                   ),
      
                   Container(
                     height: 30,
                     //width: MediaQuery.of(context).size.width*0.60,
                     child: Text(                     
                       _con.address_llevar.length>0?_con.address_llevar[index]['address']:'',
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                                    fontFamily: 'Robotos',
                                    color:select_llevar==index? Colors.white: Color(0xFFccc7c5),
                                    fontSize: 12,
                                    height: 1.2
                                           
                       ),
                     ),
                   ),
      
      
                ],
              ),
            ),
          ),
      
          Container(
            alignment: Alignment.center,
            //margin: EdgeInsets.only(left: 12),
            width: 70,
            child:BigText(text:_con.address_llevar.length>0?_con.address_llevar[index]['distance']+' km':''+' ' ,size: 12,color:select==index? Colors.white: Color(0xFFccc7c5),)
            
          ),
      
          
        ],
      ),
    ),
  );
 }


 void refresh(){
  setState(() {
    
  });
 }

}