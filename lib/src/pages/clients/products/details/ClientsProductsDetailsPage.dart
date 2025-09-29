






import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/products/details/ClientProductsDetailsController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/small_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
class ClientsProductDetailPage extends StatefulWidget {
 // final product;
 //  ClientsProductDetailPage({ Key ? key,@required this.product }) : super(key: key);
  ClientsProductDetailPage({ Key ? key }) : super(key: key);

  @override
  State<ClientsProductDetailPage> createState() => _ClientsProductDetailPageState();
}

class _ClientsProductDetailPageState extends State<ClientsProductDetailPage> {
  List<bool> _selectedExtras = List<bool>.filled(8, false); // 5 items
    // Lista que almacena los valores booleanos de los checkboxes
  List<bool> checkedValues = List<bool>.filled(10, false); // Inicialmente todos false

  ClientProductsDetailsController _con=new ClientProductsDetailsController();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
         final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        //_con.init(context, refresh,widget.product);
        _con.init(context, refresh,arguments['id']);
      });
    }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async => _con.enabled==true?false:true,
      child: Skeletonizer(
        enabled: _con.enabled,
        child: Stack(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                //controller: _con.controller,
                child: Container(
                  // margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  child: Column(
                    children: [
                       _ImagePaquete(),
                       //SizedBox(height: 10),
                          // Título del producto
  



                       _PaqueTitle(),                  
                       _PaqueteDetalle() 
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _ButtonBottom()
            ),
           _ButtonsPaqueteImage()
          ],
        ),
      ),
    );
  }
 
  Widget _PaqueteDetalle(){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
    
      decoration: BoxDecoration(
        borderRadius:BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        ),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Combinacion(),
           _Sugestive(),
           _Comentario(),
           //_buttonShoppingBag()
        ],),
    );
    //
  }

  Widget _Sugestive(){
   return     _con.sugestive.length>0?Container(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded :true,
                  title: BigText(text: 'Agrega adicionales a tu pedido',size: 15),
                  children: <Widget>[
                              SizedBox(
                                //height: 200, // Tamaño para permitir que ListView.builder se vea completo
                                child: ListView.builder(
                                  shrinkWrap: true, // Permite que ListView.builder funcione dentro de otra lista
                                  physics: NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento del ListView.builder
                                  itemCount: _con.sugestive.length, // Número de elementos en el ListView
                                  itemBuilder: (context, i) {
                                    return _buildCheckBoxTile(i);
                                  },
                                ),
                              ),
                    ],
                ),
              ),
            ):Container();
  }



  Widget _Comentario(){
   return Container(
                          height:150,
                          child: Column(
                            children: [
                                      Container(
                                        height: 30,
                                        //margin: const EdgeInsets.only(left: 0.0, right: 20.0,bottom: 0,top: 0),
                                        child: Padding
                                        (
                                          padding: const EdgeInsets.all(0),
                                            child: ListTile
                                            (                            
                                              title: BigText(text: 'COMENTARIOS',size: 15),
                                              
                                            ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        height: 110,
                                        //height: 3*24,
                                        //margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: TextField(
                                         controller: _con.comentarioController,
                                          //obscureText: true,
                                          maxLines: 3,
                                        decoration: InputDecoration(
                                          
                                          hintText: 'Detalle a tu orden',
                                          //border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(15),
                                          hintStyle: TextStyle(color: Colors.grey),
                                          //prefixIcon: Icon(Icons.edit,color: Colors.grey,),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                          ),

                                        ),
                                        
                                          
                                        ),
                                      ) 

                          
                            ],
                          ),
                         );
  }
  Widget Combinacion(){
     return  Container(

        child: ListView.builder( 
        physics: NeverScrollableScrollPhysics(),/* importante */
           shrinkWrap: true,
          itemCount:_con.selectedProducts.length>0 ? _con.selectedProducts[0]["relationships"]["detalles"].length:0,
          itemBuilder: (BuildContext context,int index){  
            return Column(
        
             children: 
             [
                SizedBox(
                  height: 25,
                  //margin: const EdgeInsets.only(left: 0.0, right: 20.0,bottom: 0,top: 0),
                  child: Padding
                  (
                      padding: const EdgeInsets.all(0),
                      child: ListTile
                      (                            
                       /* title: Text(_con.selectedProducts[0]["relationships"]["detalles"][index]["attributes"]["title"],
                        style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),  
                        */ 
                        title: BigText(text: _con.selectedProducts[0]["relationships"]["detalles"][index]["attributes"]["title"].toString(),size: 12),
                      ),
                  ),
                 ),
     
                 Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"].length,
                      itemBuilder: (BuildContext context,int index2){
                        _con.prueba3.add(_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]["es_selected"]);
                        if(_con.prueba3[_con.itemprueba]=="1")
                         {                                                                               
                            _con.prueba.add(_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["id"].toString());
                            _con.prueba2.add( _con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["id"].toString());
                         }else
                         {                                    
                            _con.prueba.add( _con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["id"].toString());
                            _con.prueba2.add(_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]["es_selected"].toString());
                         }
                            _con.prueba4.add(_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]['detalle_id'].toString());                                                                 
                            _con.itemprueba++;
     
     
                        return Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: <Widget>[
                                  // Divider(),
                                   SizedBox
                                   (
                                    
                                      height: 25,
                                      child: RadioListTile<String>
                                        (    
                                        contentPadding :EdgeInsets.all(0), 
                                        dense: true,
                                        value:_con.prueba[_con.itemprueba-1],
                                        groupValue:  _con.prueba2[_con.itemprueba-1],
                                        title:Text(_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]["producto"],style: TextStyle(fontSize: 11),) ,
                                        onChanged: (val){
                                          //print(val);
                                          setState(() { 
                                             //print("detalle es"+_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]['detalle_id'].toString());
                                             for(int i=0;i<_con.selectedProducts[0]["relationships"]["detalles"].length;i++)
                                             {
                                               for(int j=0;j<_con.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"].length;j++){
                                                   if(_con.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["detalle_id"].toString()==_con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]['detalle_id'].toString())
                                                   {
                                                              _con.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"]="0";
                                                              //print("select"+_con.selectedProducts[0]["relationships"]["detalles"][i]["relationships"]["combinaciones"][j]["attributes"]["es_selected"].toString());
                                                  }
                                                             
                                               }
                                             }
                                             _con.selectedProducts[0]["relationships"]["detalles"][index]["relationships"]["combinaciones"][index2]["attributes"]["es_selected"]="1"; 
                                             _con.calcular_nombre_combinacion();
     
                                          });  
     
                                        },
                                        activeColor: MyColors.secondaryColor
                                          
     
                                        )
                                   )                               
                                ]  
                              )  
                            )
                          ],
                        );
                      }  
                    )
                  ],
                 )
                               
             ],
            );
          }
        ),
         
     );
  }
  Widget _ButtonBottom(){
    return Container(
        height: 100,
        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
        decoration:  BoxDecoration(
          color: Colors.white,
         // color: Colors.black12,
         // color: Color.fromRGBO(211, 178, 178, 0),
         /* borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
    
          )
          */
        boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.7),
                spreadRadius: 4,
                blurRadius: 7,
                offset: Offset(0, 9), // changes position of shadow
              ),
         ],
         border: Border(
          top: BorderSide(               
            color: Colors.black,
            width: 0.1,
          ),
        ),
    
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right:20),
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
                  GestureDetector(
                    onTap: _con.rest_cantidad,
                    child: Icon(Icons.remove,color:Colors.grey)
                  ),
                  SizedBox(width: 10,),
                  BigText(text: _con.cantidad.toString(),),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: _con.sum_cantidad,
                    child: Icon(Icons.add,color:Colors.grey)
                  ),
                ],
              ),
            ),
            Flexible(
              child: 
                GestureDetector(
                  onTap: (){_con.agregar_carrito();},
                  child: Container(
                    padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right:20),
                    child: BigText(text:"S/ "+(double.parse(_con.price.toString())-double.parse(_con.descuento.toString())).toString() +" | Agregar",color: Colors.white,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyColors.secondaryColor
                    ),
    
                  ),
                ),
             
            )
          ],
        ),
    
      );
  }
  Widget _ImagePaquete(){
    return                       Container(
                        child:  _con.selectedProducts.length>0 ?  
                                 Image.network
                                 (
                                  _con.selectedProducts[0]["attributes"]["imagen_app"],
                                  //'https://portal.villachicken.com.pe/api/img/mollejitas-app-release.png',
                                 //width: double.maxFinite,
                                // width: 600,
                                  height: 200,
                                 fit: BoxFit.cover,
                                 )
                                 :
                                 Image.asset('assets/img/no-image.png'),
                      );
  }
  Widget _PaqueTitle(){
    return Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                //color: Colors.white,
                //child: Center(child:  BigText(text: _con.NombrePaquete,size: 21,),),
                 child: Center(
                  child: Column(
                    children: [
                        /*Text(
                            _con.NombrePaquete,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          */
                          BigText(text: _con.NombrePaquete ,maxlines:3,size: 18,),
                          
                          Text(
                            _con.NombreCombinacion,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                      
                    ],
                  ),
                 ),

                width: double.maxFinite,
                padding: EdgeInsets.only(top:5,bottom:0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                  )
              );
  }
  Widget _ButtonsPaqueteImage(){
    return                 Container(
      margin: EdgeInsets.symmetric(vertical: 35,horizontal: 15),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        GestureDetector(
                          onTap: (){_con.close_page();},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40/2),
                              color: Color(0xFFfcf4e4)
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF756d54),
                            ),
                          ),
                        ),
                        _con.user_type=="guest"?Container(height: 10,):GestureDetector(
                          onTap: (){_con.storeFavorite();},
                          child: Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40/2),
                                  color: MyColors.yellowcolor
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color:_con.selectedProducts.length>0 ? _con.selectedProducts[0]["attributes"]["is_favorite"]==1?Colors.red:Colors.white:Colors.red,
                                ),
                              ),
       
                            ],
                          ),
                        ),
                        /*
                        GestureDetector(
                          onTap: (){},
                          child: Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40/2),
                                  color: Color(0xFFfcf4e4)
                                ),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color(0xFF756d54),
                                ),
                              ),
                            _con.carrito_sesion.length>0?
                            Positioned(
                              right: 0,top: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Container(alignment: Alignment.center,child: Text(_con.carrito_sesion.length>0?_con.carrito_sesion.length.toString():'0',style:TextStyle(fontSize:11,color: Colors.white ),)),
                                decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(15),
                                  color: MyColors.primarycolor,
                                
                                ),
                              ),
                            ):Container(),
      
                            ],
                          ),
                        ),*/
      
                     
                ],
              ),
    );
  }
    Widget _buttonShoppingBag(){
    return Container(
      margin: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 30),
      child:ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
         //primary:MyColors.primarycolor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Agregar a la bolsa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),

              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50,top:6),
                height: 30,
                //child:Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildCheckBoxTile(index) {
    return SizedBox(
      //height: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0), // Remueve el espacio vertical
        child: CheckboxListTile(
          dense: true, // Hace que el tile sea más compacto
         //contentPadding: EdgeInsets.symmetric(vertical: 0), // Remueve el padding
          visualDensity: VisualDensity(vertical: -4), // Reduce la altura
          title: Text(_con.sugestive[index]["attributes"]["paquete"]["attributes"]["title"]),
          subtitle: Text('+S/${_con.sugestive[index]["attributes"]["paquete"]["attributes"]["precion_base"].toString()}'),
          value: _con.checkedValues[index],
          onChanged: (bool? value) {
            setState(() {
                _con.checkedValues[index] = value ?? false;
                //_con.getSugestive();
            });
          },
        ),
      ),
    );
  }



  void refresh(){
    setState(() {
          
        });
  }

}