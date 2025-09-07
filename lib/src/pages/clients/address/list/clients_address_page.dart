
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:villachicken/src/pages/clients/address/list/clients_address_page_controller.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/sidebar.dart';
class ClientsAddressListPage extends StatefulWidget {
  const ClientsAddressListPage({ Key ? key }) : super(key: key);

  @override
  State<ClientsAddressListPage> createState() => _ClientsAddressListPageState();
}

class _ClientsAddressListPageState extends State<ClientsAddressListPage> {
  ClientsAddressListController _con= new ClientsAddressListController();
  int select=0;
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
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
    
    return Container(
           decoration: BoxDecoration(
                color: Colors.white
            ),
          child: Scaffold(
             backgroundColor: Colors.white,
             appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 50, 
                    //leading: Icon(Icons.menu),
                    //title: Text('Page title'),
                title:Column(
                  children: [
                      _TopBar2()
                  ]),    
              backgroundColor: Colors.white,
              //backgroundColor: Colors.purple,
              ),
              key:_con.key,
              drawer: SideBarWidget(),
         body: Stack(
            
            children: [ 
                SingleChildScrollView(
                  child: Column(
                    children: [
                      title(),
                      MyLocationWidget(),
                      _listAddress(),


                      
                    ],
                  ),
                ),
            ],
         ),
         //bottomNavigationBar: _ButtonBottom(),

      ),
    );
  
  }
  Widget _ButtonBottom(){
    return Container(
        height: 80,
        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
        decoration: BoxDecoration(
          color: Colors.black12,
         // color: Color.fromRGBO(211, 178, 178, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)

          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Flexible(
              child: 
                GestureDetector(
                  onTap: (){},
                  //onTap: (){_con.agregar_carrito();},
                  child: Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 20,right:20),
                   // child: BigText(text:"S/ "+_con.price.toString()+" | Agregar",color: Colors.white,),
                   child: Text('Confimar Direccion'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyColors.mainColor
                    ),

                  ),
                ),
             
            )
          ],
        ),

      );
  }

 Widget customRadio(String text,int index){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: select==index? Colors.black: Colors.white,
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        */
    ),  
    child: OutlinedButton(
      onPressed: (){
        setState(() {
           select=index;
           print(select);
        });
      },  
      child: Row(   
        children: [
          Container(
            width: 30,
            child: Icon(
              Icons.location_on_rounded,
              color:select==index? Colors.white: Colors.black,
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
                      'CASA',
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                              fontFamily: 'Robotos',
                              //color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: select==index? Colors.white: Colors.black
                       ),
                     ),
                   ),
                   Container(
                      margin: EdgeInsets.only(bottom: 2),
                     child: Text(
                       '944543434',
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
                   Container(
                     height: 30,
                     //width: MediaQuery.of(context).size.width*0.60,
                     child: Text(
                       'av. primaverae 839 frente al parque sdas dasd sa dsa da sda sda dasd 123 123112312123123211 2 1 212 12312',
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                                    fontFamily: 'Robotos',
                                    color:select==index? Colors.white: Color(0xFFccc7c5),
                                    fontSize: 12,
                                    height: 1.2
                                           
                       ),
                     ),
                   )
                ],
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





 Widget _listAddress(){

   return 
  Skeletonizer(
                     enabled: _con.enabled,
                     //enabled: true,
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          
          
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
                     //width: MediaQuery.of(context).size.width*0.60,
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

  Widget _radioSelectorAddress(address, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:20),
      child: Column(
        
        children: [
          Row(
            children: [
             /* Radio(
               value: index,
               groupValue: _con.radioValue, 
               onChanged: _con.handleRadioValueChange
            
              ),
              */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Text(
                  // address?.ADD_DIR_DOMICILIO ?? '',
                   _con.address[index]['ADD_DIR_DOMICILIO'],
                   //address.address!=null ? address.address : '',
                   //'',
                   style: TextStyle(
                     fontSize: 13,
                     fontWeight: FontWeight.bold
                   ),
                 ),

                 Container(
                   height: 30,
                   width: MediaQuery.of(context).size.width*0.60,
                   child: Text(
                     // address?.ADD_DIR_REFERENCIA ?? '',
                      _con.address[index]['ADD_DIR_REFERENCIA'],
                     //address.neighborhood!=null ? address.neighborhood : '',
                     //'',
                     style: TextStyle(
                       fontSize: 12,
                       
                       
                      
                     ),
                   ),
                 ),
                 
                 

                ],
              ),


            ],
          ),
              Divider(
                color: Colors.grey[400],
              )

        ],
      ),
      
    );
  }
                    
   

 Widget MyLocationWidget(){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    
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
    child: OutlinedButton(
      onPressed: (){
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
            width: 30,
            child: Icon(
              Icons.my_location_sharp,
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

 Widget title(){
  return Container(
    width: double.infinity, 
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
    
    //height: 50,
    decoration: BoxDecoration(
        
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
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: BigText(
              text:'Mis Direcciones',
             //  color:Colors.black87,         
             size: 22,
          ),
      ),
    ),

  );
 }
Widget  _TopBar2(){
  return  Container(
              
            child: Container(
              margin: EdgeInsets.only(top: 0,bottom: 0),
              //padding: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      GestureDetector(
                            onTap: _con.openDrawer,
                            child: Container(
                              margin: EdgeInsets.only(left: 0),
                              padding: EdgeInsets.only(left: 0),
                              ///alignment: Alignment.lef,
                              child: Image.asset('assets/img/menu.png',width: 20,height: 20),
                            ),
                          ),







                  ],
                ),

                ]
              ),
            ),
          );
  }
  void refresh(){
    setState(() {
      
    });
  }
}