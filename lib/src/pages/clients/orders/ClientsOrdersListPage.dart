import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:villachicken/src/pages/clients/orders/ClientsOrderListController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/carrito_list_card.dart';
import 'package:villachicken/src/widgets/sidebar.dart';
import 'package:villachicken/src/widgets/small_text.dart';
import 'package:villachicken/src/widgets/sugestive_carrusel.dart';
import 'package:villachicken/src/widgets/title_carrusel.dart';
class ClientOrderListPage extends StatefulWidget {
  const ClientOrderListPage({ Key ? key }) : super(key: key);

  @override
  State<ClientOrderListPage> createState() => _ClientOrderListPageState();
}

class _ClientOrderListPageState extends State<ClientOrderListPage> {
     ClientsOrderListController _con=new ClientsOrderListController();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //print('inica primer init');
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
       // print('inicia sheduler binding');
        _con.init(context,refresh);
      });
    }

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
          //drawer: _drawer(),
          drawer: SideBarWidget(),
          body: SingleChildScrollView(
            controller: _con.controller,
            child: Container(
               margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
              child: Column(
                children: [
                    _ListCart(),
                  //_con.sugestive!=null && _con.sugestive.length>0?TitleCarruselWidget(text: 'Complementa tu orden',):Container(),  
                  // CardSugestive(),
                    _con.sugestive!=null && _con.sugestive.length>0?TitleCarruselWidget(text: '¿TE PROVOCA ALGO MÁS?',):Container(),  
                   CardSugestivev2()
                 // Food_Release(),
                ],
              ),
            ),
          ),
          
          bottomNavigationBar: _ButtonBottom()
          
        ),
      ),
    );
  }
  Widget _ListCart(){
return CartListWidget(
  cartItems: _con.carrito_sesion,
  onQuantityChange: (index) {
    _con.sum_cantidad(index);
    // Lógica para cambiar la cantidad de un producto
  },
  onQuantityRest: (index) {
    _con.rest_cantidad(index);
    // Lógica para cambiar la cantidad de un producto
  },

  onRemoveItem: (index) {
    _con.deletedItem(_con.carrito_sesion[index]); // Lógica para eliminar un ítem
  },
)
;    return Container(
     // margin: const EdgeInsets.only(top: 15),
    
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _con.carrito_sesion.length > 0 ? _con.carrito_sesion.length : 0,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),  // Sombra suave
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),  // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _con.carrito_sesion.length > 0
                                ? NetworkImage(_con.carrito_sesion[index]["imagen"])
                                : AssetImage('assets/img/no-image.png') as ImageProvider,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _con.carrito_sesion.length > 0 ? _con.carrito_sesion[index]["producto"] : "",
                                maxLines: 1,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Subway'),  // Estilo de texto mejorado
                              ),
                              Text(
                                _con.carrito_sesion.length > 0 ? _con.carrito_sesion[index]["combinacion"] : "",
                                style: TextStyle(
                                  color: Color(0xFFccc7c5),
                                  fontSize: 9,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  buildQuantityControl(index),  // Función para crear el control de cantidad
                                  _con.carrito_sesion.length > 0 ?
                                      double.parse(_con.carrito_sesion[index]["descuento"]) > 0 ?
                                          Text('\S/ ' + _con.carrito_sesion[index]["precio_tienda"].toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration.lineThrough
                                          ))
                                      : Container()
                                  : Container(),   
                                  BigText(
                                    text: 'S/ ' + (_con.carrito_sesion.length > 0 ? _con.carrito_sesion[index]["precio"].toString() : "0"),
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildRemoveButton(index),  // Función para crear el botón de eliminar
                    ],
                  ),
                ),
                _con.carrito_sesion[index]["isfree"]==1?Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(Icons.card_giftcard, color: Colors.orange),  
                ):Container(),
              ],
            );
          },
        ),
      ),
    );
  }
  // Función para crear el control de cantidad


Widget buildQuantityControl(int index) {
  return  _con.carrito_sesion[index]["isfree"]==0?Container(
              //padding: EdgeInsets.only(top: 1,bottom: 1,left: 2,right:2),
              padding: EdgeInsets.all(5),
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                ],
    
              ),
              child: Row(
                children: [
                  _buildQuantityButton(Icons.remove, () => _con.rest_cantidad(index)),
                  SizedBox(width: 10),
                  BigText(size: 14,text: _con.carrito_sesion.length > 0 ? _con.carrito_sesion[index]["cantidad"].toString() : "1"),
                  SizedBox(width: 10),
                  _buildQuantityButton(Icons.add, () => _con.sum_cantidad(index)),
                ],
              ),
  ):Container();
}

// Función para crear un botón de cantidad
Widget _buildQuantityButton(IconData icon, Function onTap) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Icon(icon, color: Colors.grey, size: 18),
      ),
    ),
  );
}

// Función para crear el botón de eliminar
Widget buildRemoveButton(int index) {
  return _con.carrito_sesion[index]["isfree"]==0?Container(
    alignment: Alignment.topRight,
    padding: EdgeInsets.only(top: 5, right: 5),
    width: 25,
    child: GestureDetector(
      onTap: () => { _con.deletedItem(_con.carrito_sesion[index]) },
      child: Icon(Icons.close, color: Colors.black, size: 18),
    ),
  ):Container(width: 25,);
}
  Widget _ButtonBottom(){


    return Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),  // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),  // Sombra más suave
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Cambia la posición de la sombra
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espaciado uniforme
              children: [
               
                _buildRow('Productos', 'S/ ${_con.subotal.toString()}'),
                _buildRow('Descuento', 'S/ ${_con.descuento.toString()}'),
                //_buildRow('Delivery', 'Gratis'),
                _buildRow('Delivery', 'S/ ${_con.recargo_delivery.toString()}'),
                _buildRow('Total', 'S/ ${_con.Price.toString()}'),
                const SizedBox(height: 5),

                BigButtonWidget(
                 
                  text: "Pedir S/ ${_con.Price.toString()}",
                  onTap: () => _con.goToCheckout(),
                )

                /*GestureDetector(
                  onTap: () {
                    _con.goToCheckout();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyColors.primarycolor,
                    ),
                    child: BigText(
                      text: "Pedir S/ ${_con.Price.toString()}",
                      color: Colors.white,
                    ),
                  ),
                ),
                */
              ],
            ),
          );
  }
Widget _buildRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),  // Negrita para títulos
      ),
      Text(value),
    ],
  );
}
 Widget _ButtonTop(){
  return           Positioned(
            top: 35,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                      _ButtonsTopLeft(),
                      Container(
                        child: Row(children: [
                         // Icon(Icons.shopping_cart_outlined),
                          BigText(text: "MI CARRITO",size: 17,)
                        ],),
                      )

                      //SizedBox(width: MediaQuery.of(context).size.width*0.5),
                    //  _ButtonsTopRight1(),
                    //  _ButtonsTopRight2()

              ],
            ),
          );
 }
  Widget _ButtonsTopLeft(){
    return  GestureDetector(
                        //onTap: (){_con.close_page();},
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                           // borderRadius: BorderRadius.circular(40/2),
                            //color: MyColors.primarycolor
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24 ,
                          ),
                        ),
                      );
  }
  Widget _ButtonsTopRight1(){
    return                       GestureDetector(
                        //onTap: (){_con.close_page();},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40/2),
                            color: MyColors.mainColor
                          ),
                          child: Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 24 ,
                          ),
                        ),
                      );
  }
 Widget _ButtonsTopRight2(){
  return GestureDetector(
                        //onTap: (){_con.close_page();},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40/2),
                            color: MyColors.mainColor
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 24 ,
                          ),
                        ),
                      );
 } 
 Widget CardSugestive(){
    int _index = 0;
 return _con.sugestive != null && _con.sugestive.length > 0
    ? SizedBox(
        height: 100, // altura de la tarjeta
        child: PageView.builder(
          padEnds: false,
          scrollDirection: Axis.horizontal,
          dragStartBehavior: DragStartBehavior.start,
          itemCount: _con.sugestive != null ? _con.sugestive.length : 0,
          controller: PageController(viewportFraction: 0.5), // Mantiene la fracción 0.5
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: 1,
              child: GestureDetector(
                onTap: () =>{
                  _con.GoToPaqueteDetail(i)
                },
                child: Container(
                 // color: Colors.white,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                       color: Colors.white  , 
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),  // Sombra suave
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),  // Desplazamiento de la sombra
                          ),
                        ],
                  ),
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            //color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _con.sugestive[i]["attributes"]["title"].toString(),
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "S/ " + _con.sugestive[i]["attributes"]["precion_base"].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 100,
                        margin: EdgeInsets.zero,
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: _con.sugestive[i]["attributes"]["imagen"].toString(),
                            errorWidget: (context, url, error) => Text("error"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    : SizedBox.shrink();

  }

Widget CardSugestivev2(){
  int _index = 0;
  return SugestiveCardWidget(
  sugestiveList: _con.sugestive,
  onTap: (int index) {
    //print("debug print ${index}");
    _con.GoToPaqueteDetail(index); // Llamada a la función en tu controlador
  },
  currentIndex: _index,
  controller: PageController(viewportFraction: 0.4), // Controlador de PageView
);
   // int _index = 0;
 return _con.sugestive != null && _con.sugestive.length > 0
    ? SizedBox(
        height: 220, // altura de la tarjeta
        child: PageView.builder(
           padEnds: false,
          scrollDirection: Axis.horizontal,
          dragStartBehavior: DragStartBehavior.start,
          itemCount: _con.sugestive != null ? _con.sugestive.length : 0,
          controller: PageController(viewportFraction: 0.4), // Mantiene la fracción 0.5
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: 1,
              child: GestureDetector(
                onTap: () =>{
                  _con.GoToPaqueteDetail(i)
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                       color: Colors.white  , 
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),  // Sombra suave
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),  // Desplazamiento de la sombra
                          ),
                        ],
                  ),
                  
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        margin: EdgeInsets.zero,
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: _con.sugestive[i]["attributes"]["imagen"].toString(),
                            errorWidget: (context, url, error) => Text("error"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                          //height: 100,
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            //color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 70,

                                child: Text(
                                  _con.sugestive[i]["attributes"]["title"].toString(),
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.center,
                                child: 
                                BigText(text: "S/ " + _con.sugestive[i]["attributes"]["precion_base"].toString(),size: 16,)
                                  /*Text(
                                    "S/ " + _con.sugestive[i]["attributes"]["precion_base"].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  */

                                  
                               
                              ),
                            ],
                          ),
                        ),
                    

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    : SizedBox.shrink();

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
                              
                              BigText(text: 'MI PEDIDO',size: 14, color:Colors.black)                                         
                            ],
                          ),
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
      //print('se ha reelogeado'); 
      
      });
      
  }  

}