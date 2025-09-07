import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:villachicken/src/pages/clients/checkout/ClientsCheckoutController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/addres_resume_card.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/document_check.dart';
import 'package:villachicken/src/widgets/products_resume_card.dart';
import 'package:villachicken/src/widgets/small_text.dart';
class ClientsCheckoutPage extends StatefulWidget {
  const ClientsCheckoutPage({ Key ? key }) : super(key: key);

  @override
  State<ClientsCheckoutPage> createState() => _ClientsCheckoutPageState();
}

class _ClientsCheckoutPageState extends State<ClientsCheckoutPage> {
     ClientsCheckoutController _con=new ClientsCheckoutController();
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
      body: Stack(
        children: [
           _ButtonTop(),
           Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(           
                 children:[
                  _Title_Type_Order(),
                   _Step1_Address(),
                   //_Step1_Time_Wait(),
                   _Step_ResumeOrder(),
                   //_Step_Type_Billing(),
                  // _Step_Type_Billing_boleta(),
                   _Sept_Select_Type_Document(),
                   _Step_Medio_Pago(),
                   _StepAceptTerminos(),
                  // _Sept_Select_Type_Document()
                 ] 
              ),
            ) ,
           )
        ],
      ),
      bottomNavigationBar: _ButtonBottom()
      
    );
  }
Widget _Title_Type_Order(){
  return  BigText(text: _con.setTypeOrder());
}
Widget _Step_Medio_Pago(){ 
   return  SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),  // Sombra suave
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),  // Desplazamiento de sombra
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),  // Espaciado alrededor del contenedor
                  padding: const EdgeInsets.all(15),  // Espaciado interno generoso
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildPaymentMethod(),  // Función separada para mejorar legibilidad
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
  
  }

  Widget buildPaymentMethod() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Título del medio de pago
      Row(
        children: [
           Icon(Icons.document_scanner, color: MyColors.secondaryColor),  // Ícono con color resaltado
          const SizedBox(width: 10),  // Espaciado entre ícono y texto
          BigText(
            text: '4. MEDIO DE PAGO',
            size: 12,
           // fontWeight: FontWeight.bold,  // Texto en negrita para el título
            color: Colors.black87,
          ),
        ],
      ),
      const SizedBox(height: 0),  // Espacio entre título y lista

      // Lista de medios de pago
      SizedBox(
        width: double.infinity,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _con.medio_pago.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 0),  // Espacio entre elementos de la lista
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: _con.medio_pago[index]['id'],
                    groupValue: _con.medio_pago_select,
                    onChanged: (index2) {
                      setState(() {
                        //print(index2);
                        _con.medio_pago_select = index2;  // Actualizar el medio de pago seleccionado
                        _con.listenTypeMethod();
                      });
                    },
                    activeColor: MyColors.primarycolor,  // Color activo del radio button
                  ),
                  const SizedBox(width: 1),  // Espacio entre el radio y el texto
                  Text(
                    _con.medio_pago[index]['ENT_NOMBRE'],
                    style: TextStyle(fontSize: 14, color: Colors.black87),  // Estilo de texto
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _Step_ResumeOrder(){ 
    return ProductsResumeWidget(
  title: '2. RESUMEN DE ORDEN',
  cartItems: _con.carrito_sesion, // Pasa la lista de productos del carrito
   );

   return     SingleChildScrollView(
  child: Column(
    children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),  // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),  // Sombra suave
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),  // Desplazamiento de sombra
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20),  // Espaciado fijo
            Expanded(
              child: buildOrderSummary(),  // Función separada para mejorar legibilidad
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    ],
  ),
);
  
  }

Widget buildOrderSummary() {
 
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
                Icon(Icons.edit_document, color: MyColors.secondaryColor),  // Ícono con color resaltado
          const SizedBox(width: 10),  // Espacio entre el ícono y el texto
          BigText(
            text: '2. RESUMEN DE ORDEN',
            size: 12,
            //fontWeight: FontWeight.bold,  // Texto en negrita para jerarquía
            color: Colors.black87,
          ),
        ],
      ),
      const SizedBox(height: 10),  // Espacio entre el título y la lista
      buildOrderList(),  // Llamada a la función que crea la lista de productos
    ],
  );
}

// Función para la lista de productos dentro del resumen de orden
Widget buildOrderList() {
  return Container(
    width: double.infinity,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _con.carrito_sesion.length > 0 ? _con.carrito_sesion.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Imagen del producto
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _con.carrito_sesion.length > 0
                      ? NetworkImage(_con.carrito_sesion[index]["imagen"])
                      : const AssetImage('assets/img/no-image.png') as ImageProvider,
                ),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),  // Separador de espacios
            // Cantidad de producto
            SmallText(
              text: _con.carrito_sesion.length > 0
                  ? '${_con.carrito_sesion[index]["cantidad"]} x'
                  : "1 x",
              size: 13,
            ),
            const SizedBox(width: 10),
            // Descripción del producto
            Expanded(
              child: SmallText(
                text: _con.carrito_sesion.length > 0
                    ? _con.carrito_sesion[index]["producto"]
                    : "",
                size: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 10),
            // Precio del producto
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: BigText(
                text: 'S/ ${_con.carrito_sesion.length > 0 ? _con.carrito_sesion[index]["precio"].toString() : "1"}',
                size: 14,
                color: Colors.black,  // Color verde para el precio
                //fontWeight: FontWeight.bold,  // Negrita para resaltar el precio
              ),
            ),
          ],
        );
      },
    ),
  );
}

  Widget _Step1_Address(){ 
   return Container(
  //height: 170,  // Aumentar un poco la altura para más espacio
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),  // Bordes redondeados para suavizar el contenedor
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),  // Sombra suave
        spreadRadius: 3,
        blurRadius: 5,
        offset: Offset(0, 3),  // Desplazamiento de sombra
      ),
    ],
  ),
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),  // Espacio alrededor del contenedor
  padding: const EdgeInsets.all(15),  // Espacio interno generoso
  child: Row(
    children: [
      // Separador
      const SizedBox(width: 20),
      Expanded(
        child: buildAddressDetails(),
      ),
      const SizedBox(width: 10),  // Espacio adicional
      buildStyledGoogleMap(),
    ],
  ),
);
  
  }
// Función para detalles de la dirección
Widget buildAddressDetails() {
  return AddressResumeWidget(
  title: '1. DIRECCIÓN DE ENTREGA',
  addressName: _con.address != null && _con.address.isNotEmpty
      ? _con.address[0]['ADD_ADI_NOMBRE']
      : null,
  addressDetails: _con.address != null && _con.address.isNotEmpty
      ? '${_con.address[0]['ADD_DIR_DOMICILIO']}. Ref: ${_con.address[0]['ADD_DIR_REFERENCIA']}'
      : null,
  phoneNumber: _con.address != null && _con.address.isNotEmpty
      ? _con.address[0]['ADD_ADI_TELEFONO']
      : null,
  iconColor: MyColors.secondaryColor, // Color personalizado para el icono
);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        children: [
           Icon(Icons.home, color: MyColors.secondaryColor),  // Icono con color mejorado
          const SizedBox(width: 10),  // Espacio entre icono y texto
          BigText(text: '1. DIRECCIÓN DE ENTREGA', size: 12,),  // Texto más grande y negrita
        ],
      ),
      const SizedBox(height: 5),  // Espacio entre filas
      Text(
        _con.address != null && _con.address.isNotEmpty
            ? _con.address[0]['ADD_ADI_NOMBRE']
            : 'Dirección no disponible',
        style: TextStyle(fontSize: 14, color: Colors.black87),  // Estilo de texto mejorado
      ),
      const SizedBox(height: 3),
      Text(
        _con.address != null && _con.address.isNotEmpty
            ? '${_con.address[0]['ADD_DIR_DOMICILIO']}. Ref: ${_con.address[0]['ADD_DIR_REFERENCIA']}'
            : '',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,  // Color gris suave para texto adicional
        ),
      ),
     // BigText(text: 'LLEVAR',size: 12,),
    
      const SizedBox(height: 8),  // Espacio entre filas
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigText(
            text: _con.address != null && _con.address.isNotEmpty
                ? _con.address[0]['ADD_ADI_TELEFONO']
                : '',
            size: 14,
            color: MyColors.black,  // Color resaltado para el número de teléfono
          ),
        ],
      ),
    ],
  );
}

// Función para el Google Map mejorado con bordes redondeados
Widget buildStyledGoogleMap() {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),  // Bordes redondeados
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 1,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),  // Aplica redondeo también al mapa
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _con.initialPosition,
        onMapCreated: _con.onMapCreated,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        markers: _con.markers,
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
      ),
    ),
  );
}

 Widget _Step1_Time_Wait(){ 
   return  Container(
                        height: 100,
                        width: double.maxFinite,
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                           SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     Row(
                                      children: <Widget>[
                                         Icon(Icons.timer),
                                         BigText(text:'TIEMPO ESTIMADO DE ENTREGA',size: 15,)            
                                     ]
                                    ),
                                    SmallText(text: '45 minutos aproximadamente',size: 13,)                                  
                                  ],        
                                ),
                              ),
                            ),
                            
                             SizedBox(width: 20,),


                          ],
                        ),
                  );
  
  }
Widget _Step_Type_Billing(){ 
   return  Container(
                        height: 120,
                        width: double.maxFinite,
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                           SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     Row(
                                      children: <Widget>[
                                         Icon(Icons.document_scanner),
                                         BigText(text:'Comprobante de pago',size: 12,) ,
                                         
                                                    
                                     ]
                                    ),
                                    SizedBox(
                                      height: 80,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          scrollDirection:Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: _con.tipo_comprobante.length,
                                          itemBuilder: (BuildContext context,int index){
                                              return      Row(
                                                        children: [
                                                          Radio(
                                                          
                                                            value: _con.tipo_comprobante[index]['id'], 
                                                            groupValue: _con.tipo_comprobante_select, 
                                                            onChanged: (index2) {
                                                            setState(() {  
                                                              
                                                                  
                                                                 _con.tipo_comprobante_select = index2;  
                                                             });  

                                                            },
                                                            activeColor: MyColors.primarycolor,
                                                            ),
                                                          Text(''+_con.tipo_comprobante[index]['ENT_NOMBRE'])
                                                        ],
                                                      );
                                          })

                                      ),
                                    


             
          
        

                             
                                  ],        
                                ),
                              ),
                            ),
                            
                             SizedBox(width: 20,),


                          ],
                        ),
                  );
  
  }
   Widget _Sept_Select_Type_Document(){
     return  SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),  // Sombra suave
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),  // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),  // Espaciado alrededor del contenedor
                    padding: const EdgeInsets.all(15),  // Espaciado interno generoso
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: buildPaymentReceipt(),  // Función separada para mejorar legibilidad
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
   }
   Widget _Step_Type_Billing_boleta(){ 
   return  Container(
                        height: 100,
                        width: double.maxFinite,
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                           SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     Row(
                                      children: <Widget>[
                                         Icon(Icons.edit_document),
                                         BigText(text:'BOLETA ELECTRÓNICA',size: 15,)            
                                     ]
                                    ),
                                    SmallText(text: '45 minutos aproximadamente',size: 13,)                                  
                                  ],        
                                ),
                              ),
                            ),
                            
                             SizedBox(width: 20,),


                          ],
                        ),
                  );
  
  }
  Widget buildPaymentReceipt() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Título del comprobante de pago
      Row(
        children: [
           Icon(Icons.edit_document, color: MyColors.secondaryColor),  // Ícono con color resaltado
          const SizedBox(width: 10),  // Espaciado entre ícono y texto
          BigText(
            text: '3. COMPROBANTE DE PAGO',
            size: 12,
           // fontWeight: FontWeight.bold,  // Negrita para el título
            color: Colors.black87,
          ),
        ],
      ),
      const SizedBox(height: 10),  // Espacio entre título y descripción

      // Selección de comprobante
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmallText(
            text: 'Seleccione un comprobante de pago',
            size: 14,
            color: Colors.black54,  // Texto de color más suave
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.secondaryColor, // Fondo rojo detrás del icono
                shape: BoxShape.circle, // Forma circular alrededor del icono
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Color de la sombra
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Desplazamiento de la sombra
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_right,
                size: 32,
                color: Colors.white, // Cambiado a blanco para contrastar con el fondo rojo
              ),
            ),
            onTap: () {
              _con.openModalTipoComprobante(); // Acción al tocar el icono
            },
          ),
        ],
      ),
      const SizedBox(height: 10),  // Espacio entre filas

      // Texto del tipo de comprobante seleccionado
      SmallText(
        text: _con.tipo_comprobant_nombre.isNotEmpty
            ? _con.tipo_comprobant_nombre
            : 'No seleccionado',
        size: 14,
        color: Colors.black87,  // Texto principal en negro
      ),
      const SizedBox(height: 5),

      // Mostrar información del documento solo si se ha seleccionado un comprobante
      _con.tipo_comprobante_select != 0
          ? SmallText(
              text: '${_con.tipo_comprobante_select==1?'DNI':'RUC'}: ${_con.documento} - ${_con.documento_name}',
              size: 14,
              color: Colors.black87,
            )
          : Container(),  // Si no hay comprobante, no mostrar nada
    ],
  );
}
  Widget _ButtonBottom(){

    return Container(

        height: 100,
        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
        decoration: BoxDecoration(

        border: Border(
          top: BorderSide( //                   <--- left side
            color: Colors.black,
            width: 0.1,
          ),
        ),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Flexible(
              
              child: BigButtonWidget(
                  text: "Pedir S/ ${_con.Price.toString()}",
                  onTap: () => _con.send_data(),
                ),
             
            )
          ],
        ),

      );

   
    return Container(

        height: 100,
        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
        decoration: BoxDecoration(

        border: Border(
          top: BorderSide( //                   <--- left side
            color: Colors.black,
            width: 0.1,
          ),
        ),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Flexible(
              
              child: 
                GestureDetector(
                  onTap: (){_con.send_data();},
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right:20),

                   child: BigText(text:"Pedir"+" S/ "+(_con.Price.toString()),color: Colors.white,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.primarycolor
                    ),

                  ),
                ),
             
            )
          ],
        ),

      );
  }

 Widget _ButtonTop(){
  return           Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                      _ButtonsTopLeft(),
                      Container(
                        child: Row(children: [
                          //Icon(Icons.label_outline_rounded),
                          BigText(text: "Confirma tu pedido")
                        ],),
                      ),
                      Container()

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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40/2),
                            color: MyColors.primarycolor
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
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


 Widget _StepAceptTerminos(){ 
   return  SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),  // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),  // Sombra suave
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),  // Desplazamiento de sombra
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),  // Espaciado alrededor del contenedor
                  padding: const EdgeInsets.all(15),  // Espaciado interno generoso
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: buildAceptTerminos(),  // Función separada para mejorar legibilidad
                       
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
  
  }

  Widget buildAceptTerminos() {
  return Column(
                          children: [
                            DocumentCheckWidget(
                              key: _con.checkTerKey, 
                              title: "Acepto los",
                              subtitle: "términos y condiciones",
                              initialValue: _con.checkTerminos,  
                              onTapTerms: () {
                                _con.openModalTerminos(1);
                              },
                              onChanged: (bool newValue) {
                                setState(() {
                                  _con.checkTerminos = newValue;
                                });
                              
                              },
                            ),
                            DocumentCheckWidget(
                              key: _con.checkPolKey, 
                              title: "Acepto las",
                              subtitle: "políticas de privacidad",
                              initialValue: _con.checkPoliticas,  
                              onTapTerms: () {
                                 _con.openModalTerminos(2);
                              },
                              onChanged: (bool newValue) {
                                setState(() {
                                  _con.checkPoliticas = newValue;
                                });
                              },
                            )

                           // documentCheckWidget(onTapTerms: (){}),
                          ],
                        );
}

  void refresh(){
    setState(() {
      //print('se ha reelogeado'); 
      
      });
      
  }  

}