import 'dart:async';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:villachicken/src/pages/clients/main/ClientsMainController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/footer_navigator_bar.dart';
import 'package:villachicken/src/widgets/sidebar.dart';
import 'package:villachicken/src/widgets/small_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:skeletonizer/skeletonizer.dart';

class ClientsMainPage extends StatefulWidget {
  const ClientsMainPage({ Key ?key }) : super(key: key);

  @override
  State<ClientsMainPage> createState() => _ClientsMainPageState();
}

class _ClientsMainPageState extends State<ClientsMainPage> {
    //PageController _con=new PageController(initialPage: 0);
     ClientsMainController _con=new ClientsMainController();
     //final ScrollController _controller = ScrollController();
  
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    print('inica primer init');
      //imageCache.clear();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
        _con.init(context,refresh);
       // imageCache.clear();
       print('inica primer init');
      });
    }

   late bool requiresFactor; 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _con.enabled==true?false:true,
      child: Skeletonizer(
        enabled: _con.enabled,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation :0,
            toolbarHeight: 120, 
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
          //drawer: _drawer(),
          drawer: SideBarWidget(),
          body: SingleChildScrollView(
            controller: _con.controller,
            child: Column(
              children: [
                //_TopBar(),
                //_con.slider.length>0 ? _Slider3():_lottieanimacion(1),
                _Slider3(),
                _con.descuentos!=null && _con.descuentos.length>0?Title('Con descuento'):Container(),
                _con.descuentos!=null && _con.descuentos.length>0?CardSlider():Container(),
                _con.ok!=null&& _con.ok.length>0?Food_Release():Container(),
               // Food_Release(),
              ],
            ),
          ),
          
          bottomNavigationBar:FooterNavigatorWidget(),
        
        ),
      ),
    );
  }
  Widget BottomNavigator(){
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.black, // <-- This works for fixed
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: (value) => {_con.NavigatorGoTo(value)},
            items:<BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_outlined),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_outlined),
                label: 'Promociones',
              ),

              BottomNavigationBarItem(
                icon: _con.carrito_sesion.length>0?Badge(
                label: Text(_con.carrito_sesion.length.toString()),
                child: Icon(Icons.shopping_cart),
              ):Icon(Icons.shopping_cart),
              label: 'Carrito',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
              
                label: 'Favoritos',
              ),
            ],
     );
  }
  Widget Title(name){
    return Container(
       margin: EdgeInsets.only(left: 30),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           BigText(text: "$name"),
           SizedBox(width: 10,),
           Container(
             margin: const EdgeInsets.only(bottom: 3),
             //child: BigText(text: '.',color: Colors.black26,),
           ),
           SizedBox(width: 10,),
           Container(
             margin: const EdgeInsets.only(bottom: 2),
             //child: SmallText(text: "sss",),
           )
           

         ],

       ),
    );
  }

  Widget Food_Release(){
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
        shrinkWrap: true,
        itemCount:  _con.ok!=null ? _con.ok.length : 0,
        itemBuilder:(context,index){
            return Column(
              children: [
                //Title(_con.ok[index]["attributes"]["title"].toLowerCase()),
                Title(_con.ok[index]["attributes"]["title"].substring(0, 1)+""+_con.ok[index]["attributes"]["title"].toLowerCase().substring(1)),
                //Text(index.toString()),
                Food_Release_list(index)
              ],
            );
        }
    
      ),
    
    );
  }
  Widget Food_Release_list(num){
     return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
        shrinkWrap: true,
        itemCount:  _con.ok!=null ? 1 : 0,
        itemBuilder:(context,index){
          //print(num);
         
          for (var i = 0; i <  _con.ok[num]["relationships"]["paquetes"].length; i++) {
             //print(_con.ok[num]["relationships"]["paquetes"][i]["attributes"]["title"].toString());
              //Food_Rest_List_Card(num,i);
              
              return Column(
               children: [
                 Food_Rest_List_Card(num,i)
               ],
              );
              //Food();
              /* return Column(
              children: [
                //Title(_con.ok[num]["relationships"]["paquetes"][index]["attributes"]["title"]),
                Text(_con.ok[num]["relationships"]["paquetes"][i]!=null ? _con.ok[num]["relationships"]["paquetes"][i]["attributes"].toString() : ""),
              ],
             );
             */


            
          }// fin foreach


        }

      ),

    );   
  }
  Widget Food_Rest_List_Card(index,paqcount){
    return Container(
      //height: MediaQuery.of(context).size.height*0.5,
      //height: 1200,
      //  height: 1200,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
  
        shrinkWrap: true,

      itemCount:   _con.ok!=null ? _con.ok[index]["relationships"]["paquetes"].length : 0,
    
      itemBuilder:(context,index2){

       return Container(
         margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
         child: GestureDetector(
          //onTap: (){_con.openBottomShhet(_con.promociones[index]);},
          //onTap: (){_con.openBottomShhet(_con.ok[index]["relationships"]["paquetes"][index2]);},
          onTap: (){_con.openBottomShhet(_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["paq_tienda_id"]);},
           child: Row(
             children: [
              /* Container(
                 width: 120,
                 height: 120,
                 margin: EdgeInsets.only(top: 5,bottom: 5),
                 decoration:BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.white,
                   image: DecorationImage(
                     // image: NetworkImage(_con.carta["data"]["relationships"]["paquetes"][index]["attributes"]["imagen"]),
                    // image:_con.carta!=null ? NetworkImage(_con.carta["data"]["relationships"]["paquetes"][index]["attributes"]["imagen"]) :null ,
                    
                    //image: NetworkImage("https://portal.villachicken.com.pe/api/img/promo-duo.jpg"),
                    image: _con.ok!=null ?  NetworkImage(_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["imagen"]):
                           AssetImage('assets/img/no-image.png'),
                   fit: BoxFit.cover
                    )
                 ),
                 
               ),
               */

            
                  Container(
                 width: 100,
                 height: 100,
                  margin: EdgeInsets.only(top: 5,bottom: 5),
                  
                             
                                child:ClipRRect(borderRadius: BorderRadius.circular(10),
                                child:CachedNetworkImage(
                                  
                                  placeholder: (context, url) =>       const        SizedBox(
                
                height: 10,
                width: 10,
                //child: CircularProgressIndicator(color: Colors.red,),
              ),
                                     imageUrl: _con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["imagen"],
                                      errorWidget: (context, url, error) => Text("error"),
                                    fit: BoxFit.cover,
                                  )),
                           
                            ),



               Expanded(
                 child: Container(
                   height: 130,
                   //width: 100,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(
                       topRight: Radius.circular(20),
                       bottomRight: Radius.circular(20)
                       ),
                     color: Colors.white
                   ),
                   child: Padding(
                     padding: EdgeInsets.only(left: 10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         double.parse(_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["descuento_percent"].toString())>0?
                          /*Badge(
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: Colors.yellow,
                            padding: EdgeInsets.only(top: 2,bottom: 2),
                             
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(double.parse(_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["descuento_percent"].toString()).toString()+''+'% DCTO', 
                            style: TextStyle(color: Colors.black,fontSize: 11)),
                          )*/SizedBox():SizedBox(),
                          SizedBox(height: 5,),
                           Text(
                           _con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["title"].toString(),
                           maxLines: 2,
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                             fontFamily: 'RobotoMono'
                           ),
                           ),
                         SizedBox(height: 10,),
                         /*SmallText(text: _con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["descripcion"].toString(),
                         ),
                         */
                      Container(
                    
                          child: Text(
                               
                                  //_con.getDetalle(index, index2),
                                  _con.ok[index]["attributes"]["descripcion"],
                                  style: TextStyle(
                                    fontFamily: 'Robotos',
                                    color: Color(0xFFccc7c5),
                                    fontSize: 12,
                                    height: 1.2
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
    
                                 )
                       
                      ),

                         SizedBox(height: 10,),
                         Row(
                           children: [
                              /*Text(
                                "S/"+_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["precion_base"].toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                ),
                              ),*/
                              BigText(text: "S/"+_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["precion_base"].toString(),                                color: Colors.black,
                                size: 16,),
                              SizedBox(width: 10), // give it width,
                              double.parse(_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["descuento"].toString())>0?
                              Text('\S/'+_con.ok[index]["relationships"]["paquetes"][index2]["attributes"]["precion_tienda"].toString(), 
                                style: TextStyle(
                                   fontSize: 12,
                                  decoration: TextDecoration.lineThrough
                                  ))
                              :Text('')
                           ],
                         )

                         
                       ],
                     ),
                   ),
                 ),
               )
             ],
           ),
         )
       );
      }));
  }

  Widget Food_Rest(){
    return Container(
      //height: MediaQuery.of(context).size.height*0.5,
      //height: 1200,
      //  height: 1200,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
        //shrinkWrap: true,
        shrinkWrap: true,
      //itemCount: _con.carta["data"]["relationships"]["paquetes"].length,
      //itemCount:  _con.carta!=null ? _con.carta["data"]["relationships"]["paquetes"].length : 0,
      itemCount:  _con.promociones!=null ? _con.promociones.length : 0,
      //itemCount: 1,
      itemBuilder:(context,index){
       // print(_con.carta["data"]["relationships"]["paquetes"][index]["attributes"]["imagen"]);
       return Container(
         margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
         child: GestureDetector(
          onTap: (){_con.openBottomShhet(_con.promociones[index]);},
          //onTap: (){_con.paquetedetalles(_con.promociones[index]);},
           child: Row(
             children: [
               Container(
                 width: 120,
                 height: 120,
                 margin: EdgeInsets.only(top: 5,bottom: 5),
                 decoration:BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.white,
                   image: DecorationImage(
                     // image: NetworkImage(_con.carta["data"]["relationships"]["paquetes"][index]["attributes"]["imagen"]),
                    // image:_con.carta!=null ? NetworkImage(_con.carta["data"]["relationships"]["paquetes"][index]["attributes"]["imagen"]) :null ,
                    
                    image: NetworkImage("https://portal.villachicken.com.pe/api/img/promo-duo.jpg"),
                    //image: _con.promociones!=null ?  NetworkImage(_con.promociones[index]["attributes"]["imagen"]): AssetImage('assets/img/no-image.png'),
                   fit: BoxFit.cover
                    )
                 )
               ),


               Expanded(
                 child: Container(
                   height: 100,
                   //width: 100,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(
                       topRight: Radius.circular(20),
                       bottomRight: Radius.circular(20)
                       ),
                     color: Colors.white
                   ),
                   child: Padding(
                     padding: EdgeInsets.only(left: 10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           _con.promociones[index]["attributes"]["title"],
                           maxLines: 2,
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                             fontFamily: 'RobotoMono'
                           ),
                         ),
                         SizedBox(height: 10,),
                         SmallText(text: "descripcin",
                         ),
                         SizedBox(height: 10,),
                         Row(
                           children: [
                              Text(
                                "S/"+_con.promociones[index]["attributes"]["precion_base"]
                              ),
                              SizedBox(width: 20), // give it width,
                              Text('\S/'+_con.promociones[index]["attributes"]["precion_base"], style: TextStyle(decoration: TextDecoration.lineThrough))
                           ],
                         )

                         
                       ],
                     ),
                   ),
                 ),
               )
             ],
           ),
         )
       );
      }),
    );
  }
  Widget CardSlider(){
    int _index = 0;
  return SizedBox(
          height: 120, // card height
          child: PageView.builder(
            //itemCount: 10,
            itemCount: _con.descuentos!=null?_con.descuentos.length:0,
            controller: PageController(viewportFraction: 0.85),
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (_, i) {
              return Transform.scale(
                //scale: i == _index ? 1 : 0.9,
                scale: 1,
                child: GestureDetector(
                   onTap: (){_con.openBottomShhet(_con.descuentos[i]["attributes"]["paq_tienda_id"]);},
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    /*child: Center(
                      child: Text(
                        "Card ${i + 1}",
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                    */
                    child: Row(
                      children: [
  
  
             Expanded(
               child: Container(
                   height: 100,
                   //width: 100,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(
                       topRight: Radius.circular(20),
                       bottomRight: Radius.circular(20)
                       ),
                     color: Colors.white
                   ),
                   child: Padding(
                     padding: EdgeInsets.only(left: 0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           //"1/4 pollo + papas + ensalda + asdasd + asdsa",
                           _con.descuentos[i]["attributes"]["title"].toString(),
                           maxLines: 2,
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                             fontFamily: 'RobotoMono'
                           ),
                         ),
                         SizedBox(height: 5,),
                         SmallText(text: _con.descuentos[i]["attributes"]["descripcion"].toString(),
                         fontFamily: 'Robotos',
                         ),
                         SizedBox(height: 10,),
                         Row(
                           children: [
                              /*Text(
                                "S/ "+_con.descuentos[i]["attributes"]["precion_base"].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    
                                  ),
  
                              ),
                              */
                              BigText(text: "S/ "+_con.descuentos[i]["attributes"]["precion_base"].toString(),color: Colors.black,size: 16,),
                              SizedBox(width: 10), // give it width,
                              Text('\S/ '+_con.descuentos[i]["attributes"]["precion_tienda"].toString(), 
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough
                                      ))
                           ],
                         )
  
                         
                       ],
                     ),
                   ),
               ),
             ),
                            /*Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(top: 15,left: 15,bottom: 15),
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage("https://portal.villachicken.com.pe/api/img/parrillas-web02.png"),
                                    fit: BoxFit.cover
                                  )
                              )
                            ),*/
                    Container(
                   width: 100,
                   height: 100,
                    margin: EdgeInsets.only(top: 5,bottom: 5),
                    
                               
                                  child:ClipRRect(borderRadius: BorderRadius.circular(20),
                                  child:CachedNetworkImage(
                                       imageUrl: _con.descuentos[i]["attributes"]["imagen"].toString(),
                                       errorWidget: (context, url, error) => Text("error"),
                                        fit: BoxFit.cover,
                                  )),
                                  /*child:CachedNetworkImage(
                                    
                                    placeholder: (context, url) => 
                                       const CircularProgressIndicator(),
                                       imageUrl: _con.descuentos[i]["attributes"]["imagen"].toString(),
                                       errorWidget: (context, url, error) => Text("error"),
                                        fit: BoxFit.cover,
                                    )),
                                    */
                             
                              ),
  
  
  
  
  
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );

  }

  Widget Food(){
    return Container(
      //height: MediaQuery.of(context).size.height*0.5,
      height: 900,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
        //shrinkWrap: true,
      itemCount: 15,
      itemBuilder:(context,index){
       return Container(
         margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
         child: Row(
           children: [
             Container(
               width: 120,
               height: 120,
               margin: EdgeInsets.only(top: 5,bottom: 5),
               decoration:BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.white,
                 image: DecorationImage(image: NetworkImage("https://portal.villachicken.com.pe/api/img/14pollopapas-ensalada.png"),
                 fit: BoxFit.cover
                  )
               )
             ),


             Expanded(
               child: Container(
                 height: 100,
                 //width: 100,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                     topRight: Radius.circular(20),
                     bottomRight: Radius.circular(20)
                     ),
                   color: Colors.white
                 ),
                 child: Padding(
                   padding: EdgeInsets.only(left: 10),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         "1/4 POLLO + PAPAS FRITAS + ENSALADA + BEBIDA NATURAL",
                         maxLines: 2,
                         style: TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                           fontFamily: 'RobotoMono'
                         ),
                       ),
                       SizedBox(height: 10,),
                       SmallText(text: "descripcin",
                       ),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                            Text(
                              "S/ 79.90"
                            ),
                            SizedBox(width: 20), // give it width,
                            Text('\S/ 79.90', style: TextStyle(decoration: TextDecoration.lineThrough))
                         ],
                       )

                       
                     ],
                   ),
                 ),
               ),
             )
           ],
         )
       );
      }),
    );
  }
  Widget _family(){
    return Container(
      
      child: Column(
        children: [
          Text("2"),
           Text("2"),
            Text("2"),
             Text("2"),
              Text("2"),
               Text("1")
        ],
      )
    );
  }
  Widget _Slider3(){
    return  SizedBox(
      
      height: 200,
       child: ListView(
         physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions
                    (
                    
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16/9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8
                    ),
                  /*items: [_con.slider["data"]]?.map<Widget>((document) {
                           print(document);
                    }).toList()
                  */
                  items:  List<Widget>.generate( _con.slider.length  ,(index){
                    return GestureDetector(
                      //onTap: (){print(_con.slider["data"][index]["id"]);},
    
                      onTap: (){_con.openBottomSliderSheet(_con.slider[index]["ref"]);},
                      child: Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width, 
                           // height: 300,
                            //width: 700,                  
                            //height: 250,
                            //margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(                          
                              //color: Colors.amber
                            ),                       
                            //child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                            child: Container(
                              //margin: EdgeInsets.all(5),
                              //height: 200,
                              //margin: EdgeInsets.all(20),
                             // height: 500,
                             // width: 500,
                              child: Center(
                                
                                child:CachedNetworkImage(
                                     imageUrl: _con.slider[index]["attributes"]["image_sm"],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => Image.asset('assets/img/no-image.png'),
                                  )
                                
                                
                              //child: Image.network(_con.slider[index]["attributes"]["image_sm"]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                        
                   }).toList()  
                )
          ],
       ),
      );
  }

  Widget _Slider2(){
     final List<String> imagesList = [
         "https://villachicken.com.pe/villaweb/images/Slider/miercoles-pollo-web-portada.png",
         "https://villachicken.com.pe/villaweb/images/Slider/Slider-02.jpg",
         "https://villachicken.com.pe/villaweb/images/Slider/Slider-03.jpg"

         
         ];
    return Expanded(
     child: ListView(
        children: <Widget>[
              CarouselSlider(
                options: CarouselOptions
                  (
                  
                  height: 150.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16/9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8
                  ),
                items: imagesList.map((i) {
                  return GestureDetector(
                    //onTap: (){print(i);},
                    child: Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                         
                          //height: 250,
                          //margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            
                            //color: Colors.amber
                          ),
                          
                          //child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                          child: Container(
                            //margin: EdgeInsets.all(5),
                            //height: 200,
                            //margin: EdgeInsets.all(20),
                            child: Center(
                              child: Image.network(''+i.toString()),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              )
        ],
     ),
    );
  }
  Widget  _TopBar(){
  return  Container(
              
            child: Container(
              margin: EdgeInsets.only(top: 45,bottom: 15),
              padding: EdgeInsets.only(left: 20,right: 20),
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

                    Column(
                      children: [



                      BigText(text: "Villa Chicken",color: MyColors.mainColor,),
                      Row(
                        children: [
                          SmallText(text: "Jesus maria 123",color:Colors.black54),
                          Icon(Icons.arrow_drop_up_rounded)
                        ],
                      )
                      
                      ],
                    ),
                    GestureDetector(
                      //onTap:(){_con.scrollDown();},
                      child: Center(
                        child: Container(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.search,color: Colors.white,),
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(15),
                            color: MyColors.mainColor,
                          ),

                        ),
                      ),
                    ),




                  ],
                ),
                DefaultTabController(
                      length:_con.ok!=null ? _con.ok.length : 0,
                      child:TabBar(
                        onTap: (selectedIndex){
                          //print(selectedIndex);
                          _con.scrollDown(selectedIndex);
                        },
                        indicatorColor: MyColors.primarycolor,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[400],
                        isScrollable: true,
                        tabs:  List<Widget>.generate(_con.ok!=null ? _con.ok.length : 0, (index){
                            return Tab(
                              child:Text(_con.ok[index]["attributes"]["title"].substring(0, 1)+""+_con.ok[index]["attributes"]["title"].toLowerCase().substring(1) )
                            );
                        }),      
                      ) ,
                      )
                ]
              ),
            ),
          );
  }

Widget  _TopBar2(){
  return  Container(
              
            child: Container(
              margin: EdgeInsets.only(top: 0,bottom: 15),
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

                    Expanded(
                      child: Container(
                          //width: 45,
                          height: 20,
                             //margin: EdgeInsets.only(left: 0),
                              padding: EdgeInsets.only(left: 15,right: 0),
                        child: Column(
                          children: [



                          //BigText(text: _con.address!=null && _con.address.length>0? _con.address[0]['ADD_ADI_NOMBRE']:'',color: MyColors.mainColor,),
                         BigText(text:  _con.setAddrssName().toUpperCase(), size: 11,color:Colors.black)
                         /*Text(
                           //_con.address!=null  && _con.address.length>0 ? _con.address[0]['ADD_DIR_DOMICILIO']:'',
                           _con.setAddrssName(),
                           maxLines: 1,
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                             //fontFamily: 'RobotoMono',
                             color:Colors.black
                           ),
                         ),
                         */
                         
                        

                         /* Row(
                            children: [


                              //SmallText(text: _con.address!=null  && _con.address.length>0 ? _con.address[0]['ADD_DIR_DOMICILIO']:'',color:Colors.black54),
                              Icon(Icons.arrow_drop_up_rounded)
                            ],
                          ),
                          */



                          
                          ],
                        ),
                      ),
                    ),
                     GestureDetector(
                      onTap: _con.ShowAddressBottomShet,
                     
                       child: Container(
                        margin: EdgeInsets.only(bottom: 5,left: 0),
                               width: 45,
                            height: 45,                   
                        child: Icon(Icons.arrow_drop_down_rounded,color: Colors.black,)
                    ),
                     ),

                     /*
                    GestureDetector(
                      //onTap:(){_con.scrollDown();},
                      child: Center(
                        child: Container(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(15),
                           // color: MyColors.mainColor,
                          ),

                        ),
                      ),
                    ),
                    */
                    




                  ],
                ),
                DefaultTabController(
                      length:_con.ok!=null ? _con.ok.length : 0,
                  
                         //width: MediaQuery.of(context).size.width / 1.1,
                         
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.only(right: 5),
                          dividerColor: Colors.transparent,
                          onTap: (selectedIndex){
                            //print(selectedIndex);
                            _con.scrollDown(selectedIndex);
                          },
                          //indicatorColor: MyColors.primarycolor,
                          indicatorColor: Colors.white.withOpacity(0),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                          isScrollable: true,
                          tabs:  List<Widget>.generate(_con.ok!=null ? _con.ok.length : 0, (index){
                              /*return Tab(
                                child:Text(_con.ok[index]["attributes"]["title"].substring(0, 1)+""+_con.ok[index]["attributes"]["title"].toLowerCase().substring(1),
                                 style: TextStyle(fontSize: 10), )
                              );
                              */
                              return ElevatedButton(
                                                style:ElevatedButton.styleFrom(      
                                                    backgroundColor: _con.selectFamily==index?MyColors.secondaryColor:Colors.white,
                                                   foregroundColor: _con.selectFamily==index?Colors.white:Colors.black
                                                  ),
                                               onPressed: () => setState(() {
                                                   _con.selectFamily=index;
                                                  // print(index);
                                                   _con.scrollDown(index);
                                                }),
                                                //child: Text(_con.ok[index]["attributes"]["title"].substring(0, 1)+""+_con.ok[index]["attributes"]["title"].toLowerCase().substring(1)),
                                                child: Text("${_con.ok[index]["attributes"]["title"].toUpperCase() }"),
                                              );
                          }),      
                        ),
                     
                      ),


      

                ]
              ),
            ),
          );
  }

  Widget _SliderBody(){
  return Expanded(
            child: Container(
              child: ListView(
                children: [
                  LimitedBox(
                     maxHeight: 250,
                     child: PageView(
                      children: [
                         _Slider("https://villachicken.com.pe/villaweb/images/Slider/miercoles-pollo-web-portada.png"),
                         _Slider("https://villachicken.com.pe/villaweb/images/Slider/Slider-02.jpg")
                      ],
                     ),

                  )
                  
                ],
 
              ),
            ),
          );

  }
  Widget _Slider(title){
    return  
           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                   child: Container
                    (
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: title,
                          fit: BoxFit.cover,
                        )
                              /*Image.network(
                               title,
                                fit: BoxFit.cover
                               ),
                               */
                      )
                    ),        
               ),
            );
  }


 Widget _drawer(){
    return Drawer(
      child:ListView(// se posiciona 1 debajo del otro
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primarycolor
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 'Nombre del usuario',
                 
                 style: TextStyle(
                 fontSize: 18,
                 color: Colors.white,
                 fontWeight: FontWeight.bold
                 ),
                 maxLines: 1,
               ),

               Text(
                 'Email',
                 
                 style: TextStyle(
                 fontSize: 13,
                 color: Colors.grey[200],
                 fontWeight: FontWeight.bold,
                 fontStyle: FontStyle.italic
                 ),
                 maxLines: 1,
               ),

               Text(
                 'Telefono',
                 
                 style: TextStyle(
                 fontSize: 13,
                 color: Colors.grey[200],
                 fontWeight: FontWeight.bold,
                 fontStyle: FontStyle.italic
                 ),
                 maxLines: 1,
               ),
               Container(
                 height: 60,
                 margin: EdgeInsets.only(top: 10),
                 child: FadeInImage(
                   image: AssetImage('assets/img/no-image.png'), 
                   fit:BoxFit.contain,
                   fadeInDuration: Duration(milliseconds: 50),
                   placeholder: AssetImage('assets/img/no-image.png'),
                 ),
               )

             ],
          )),
         ListTile(
            title: Text('Inicio'),
            trailing: Icon(Icons.home),
            onTap: ()=>{_con.gotohome()},
            //leading: Icon(Icons.cancel),

          ),
          ListTile(
            title: Text('Mi perfil'),
            trailing: Icon(Icons.person),
            //leading: Icon(Icons.cancel),

          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart_outlined),
          
          ),
          ListTile(
            title: Text('Mis direcciones'),
            trailing: Icon(Icons.exit_to_app),
            onTap: ()=>{_con.gotoaddress()},
          
          ),
          ListTile(
            title: Text('Mis cupones'),
            trailing: Icon(Icons.computer_rounded),
          
          ),


          ListTile(
            title: Text('Cerrar Sesion'),
            trailing: Icon(Icons.exit_to_app),
            onTap: ()=>{_con.logout()},
          
          ),
          ListTile(
            title: Text('test'),
            trailing: Icon(Icons.exit_to_app),
            onTap: ()=>{_con.gototest()},
          
          ),
          ListTile(
            title: Text('Home'),
            trailing: Icon(Icons.exit_to_app),
            onTap: ()=>{_con.gotoWelcome()},
          
          )
        ],

      )
    );
  }






  void refresh(){
    setState(() 
    {
      //print('se ha reelogeado'); 
    
    });
      
  }
    Widget _lottieanimacion(count){
    return 
    Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),/* importante */
        shrinkWrap: true,
        itemCount:  count,
        itemBuilder:(context,index){
              return Container(
              margin: EdgeInsets.only(
              // top:156,
              // bottom: MediaQuery.of(context).size.height*0.05
              ),

              child: Lottie.asset('assets/json/preloader.json',
              width: MediaQuery.of(context).size.width*1,
              height: 100,
              fit: BoxFit.fill),
            );     
        }
        )
    );



  }  

}

class SliderCard extends StatelessWidget {
  const SliderCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   /* return Container(
      height: 200,
      child: Image.network("https://villachicken.com.pe/villaweb/images/Slider/miercoles-pollo-web-portada.png"),
    );
   */
   return Expanded(
     child: PageView.builder(
       
       itemCount: 2,
       itemBuilder: (context,position){
           return _buildPage(position);
       },
     ),
   );
  }
  Widget _buildPage(int index){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 55,right:5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: MyColors.mainblackcolor,
        /*image:DecorationImage(
           image: ("s")
        )
        */
      ),
    );
  }
}