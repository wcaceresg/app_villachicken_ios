import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:villachicken/src/pages/clients/favorites/ClientsFavoriteController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/small_text.dart';
class ClientsFavoritesPage extends StatefulWidget {
  const ClientsFavoritesPage({ Key ? key }) : super(key: key);

  @override
  State<ClientsFavoritesPage> createState() => _ClientsFavoritesPageState();
}

class _ClientsFavoritesPageState extends State<ClientsFavoritesPage> {
     ClientsFavoriteController _con=new ClientsFavoriteController();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
      color: MyColors.white,
        child: Stack(
          children: [
             _ButtonTop(),
             Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Container(
                         height: 1,
                          width: double.maxFinite,
                       decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: MyColors.black,
                            width: 0.1,
                          )
                        )
                       ),
                     
               ),
             ),
             _ListCart()
          
        
        
          ],
        ),
      ),
      //bottomNavigationBar: _ButtonBottom()
      
    );
  }
  Widget _ListCart(){
    return Positioned(
          top: 55,
          left: 20,
          right: 20,
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _con.favorites.length > 0 ? _con.favorites.length : 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {_con.goToDetallePaquete(_con.favorites[index]['attributes']['paq_tienda_id'])},
                    child: Container(
                      //height: 100,
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
                                image: _con.favorites.length > 0
                                    ? NetworkImage(_con.favorites[index]["attributes"]["imagen"])
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
                                    _con.favorites.length > 0 ? _con.favorites[index]["attributes"]["title"] : "",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),  // Estilo de texto mejorado
                                  ),
                                  Text(
                                    _con.favorites.length > 0 ? _con.favorites[index]["attributes"]["descripcion"] : "",
                                    style: TextStyle(
                                      color: Color(0xFFccc7c5),
                                      fontSize: 9,
                                      height: 1.1,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        // Función para crear el control de cantidad
                                      BigText(
                                        text: 'S/ ' + (_con.favorites.length > 0 ? _con.favorites[index]["attributes"]["precion_tienda"].toString() : "0"),
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
                  );
                },
              ),
            ),
          ),
        );
  }
  // Función para crear el control de cantidad


Widget buildRemoveButton(int index) {
  return Container(
    alignment: Alignment.topRight,
    padding: EdgeInsets.only(top: 5, right: 5),
    width: 25,
    child: GestureDetector(
      onTap: () => { _con.deleteFavorite(index) },
      child: Icon(Icons.close, color: Colors.black, size: 18),
    ),
  );
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

  Widget _ButtonBottom(){
    return Container(
            width: double.infinity,
            height: 170,
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
            /*child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espaciado uniforme
              children: [
               
                _buildRow('Productos', 'S/ ${_con.Price.toString()}'),
                _buildRow('Delivery', 'Gratis'),
                _buildRow('Total', 'S/ ${_con.Price.toString()}'),
                const SizedBox(height: 5),
                GestureDetector(
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
              ],
            ),
            */
          );
  }
Widget _buildRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
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
                          BigText(text: "MIS FAVORITOS",size: 17,)
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
                        onTap: (){_con.close_page();},
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

  void refresh(){
    setState(() {
      //print('se ha reelogeado'); 
      
      });
      
  }  

}