
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/checkout/comprobante/ClientsTipoComprobanteController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/text_form_field.dart';
class ClientsTipoComprobantePage extends StatefulWidget {
  final arguments;
 
  const ClientsTipoComprobantePage({super.key,@required this.arguments});
  //const ClientsTipoComprobantePage({ Key ?  key }) : super(key: key);

  @override
  State<ClientsTipoComprobantePage> createState() => _ClientsTipoComprobantePageState();
}

class _ClientsTipoComprobantePageState extends State<ClientsTipoComprobantePage> {
    ClientsTipoComprobanteController _con=new ClientsTipoComprobanteController();
  @override
    void initState() {
      super.initState();
      
       SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          // _con.init(context,refresh,widget.paxargument,widget.mesa_status);
          _con.init(context,refresh,widget.arguments);
       });

    }

  @override
  Widget build(BuildContext context) {
    return Container(
       height: MediaQuery.of(context).size.height*0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SELECCIONE EL COMPROBANTE',style: TextStyle(color: Colors.white,fontSize: 15),),
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.secondaryColor,
          actions: <Widget>[
               IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              
                onPressed: () {
                     _con.register();
                },
              )
        ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          //alignment: AlignmentDirectional.centerEnd,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,             
              children: [
                SizedBox(height: 5),
                _type_comprobante(),
                _con.tipo_comprobante_select==1?_fom_boleta():Container(),
                _con.tipo_comprobante_select==2?_form_factura():Container(),
                SizedBox(height: 15),
                BigButtonWidget(text: 'Siguiente', onTap: ()=>{_con.register()})
               ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _type_comprobante(){
    return SizedBox(
                                          //height: 80,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              scrollDirection:Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: _con.tipo_comprobante.length,
                                              physics: const ClampingScrollPhysics(),
                                              itemBuilder: (BuildContext context,int index){
                                                  return      Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(''+_con.tipo_comprobante[index]['ENT_NOMBRE']),
                                                              Radio(
                                                                value: _con.tipo_comprobante[index]['id'], 
                                                                groupValue: _con.tipo_comprobante_select, 
                                                                onChanged: (index2) {
                                                                setState(() {  
                                                                  _con.tipo_comprobante_select = index2; 
                                                                  _con.typeDocumentChange();                                                                   
                                                                });  
                                                                },
                                                                activeColor: MyColors.primarycolor,
                                                                ),
                                                            ],
                                                          );
                                              })
              
                                          );
  }
  Widget _form_factura(){
    return  Form(
          key: _con.formkeyFactura,
      child: Column(
        children: [
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinea el botón a la parte inferior
                    children: [
                      Expanded(
                        child:TextFormFieldWidget(
                              controller: _con.factura_document_controller,
                              focusNode: _con.FacturaDocumentNodeFocus,
                              labelText: 'INGRESE RUC',
                              keyboardType: TextInputType.number,
                              maxLength: 11, // Puedes especificar la longitud máxima aquí
                              validator: (value) {
                                // Elimina espacios en blanco
                                String newValue = value?.replaceAll(RegExp(r"\s+"), "") ?? "";

                                // Validación: Campo vacío
                                if (newValue.isEmpty) {
                                  return 'Ingrese el número de RUC';
                                }

                                // Validación: Verifica si es un número entero
                                if (!RegExp(r'^\d+$').hasMatch(newValue)) {
                                  return 'Solo se permiten números enteros';
                                }

                                // Validación: Verifica la longitud de 11 dígitos
                                if (newValue.length != 11) {
                                  return 'El número de RUC debe tener exactamente 11 dígitos';
                                }

                                return null; // Si todo es válido
                              },
                            ), 
                        
                        /*TextFormField(
                              controller: _con.factura_document_controller,
                              focusNode: _con.FacturaDocumentNodeFocus,
                              maxLength: 11, // Limita a 11 caracteres
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
                                  borderSide: BorderSide(color: MyColors.white), // Color del borde
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: MyColors.black), // Color del borde cuando está habilitado
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  //borderSide: BorderSide(color: MyColors.white, width: 2), // Color del borde cuando está enfocado
                                  
                                ),

                                labelText: 'INGRESE RUC',
                                labelStyle: TextStyle(color: MyColors.white), // Color de la etiqueta
                                floatingLabelStyle: TextStyle(
                                  color: MyColors.black, // Color de la etiqueta cuando está en foco
                                  height: 100
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never, // Comportamiento de la etiqueta

                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Espacio interno
                                filled: true,
                                fillColor: MyColors.black, // Color de fondo
                                counterText: '', // Elimina el contador de caracteres
                              ),
                              style: TextStyle(fontSize: 14, color: Colors.white), // Tamaño y color de fuente
                              validator: (value) {
                                // Elimina espacios en blanco
                                String newValue = value?.replaceAll(RegExp(r"\s+"), "") ?? "";

                                // Validación: Campo vacío
                                if (newValue.isEmpty) {
                                  return 'Ingrese el número de RUC';
                                }

                                // Validación: Verifica si es un número entero
                                if (!RegExp(r'^\d+$').hasMatch(newValue)) {
                                  return 'Solo se permiten números enteros';
                                }

                                // Validación: Verifica la longitud de 11 dígitos
                                if (newValue.length != 11) {
                                  return 'El número de RUC debe tener exactamente 11 dígitos';
                                }

                                return null; // Si todo es válido
                              },
                            ),*/
                      ),
                      SizedBox(width: 8), // Espacio entre el TextFormField y el botón
                      ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                               _con.searchClient();
                            },
                            child: Icon(Icons.search), // Icono de búsqueda
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(10), // Ajusta el padding del botón
                              minimumSize: Size(40, 40), // Altura y ancho del botón
                              shape: CircleBorder(), // Hace el botón circular
                            ),
                      ),
                    ],
                  ),
                 SizedBox(height: 10),
                           TextFormFieldWidget(
                              controller: _con.factura_nombre_controller,
                              focusNode: _con.FacturaNombreNodeFocus,
                              labelText: 'INGRESE RAZÓN SOCIAL',
                              keyboardType: TextInputType.text,
                              maxLength: 100, // Puedes especificar la longitud máxima aquí
                              validator: (value) {
                                String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");               
                                    if (newValue?.length == 0) {
                                          return 'Ingre razón social';
                                    }
                                    else if (newValue!.length<6) {
                                          return 'Mínimo 5 caracteres';
                                    }
                                    else{
                                      return null;
                                    }
                              },
                            ),
                 

                 /*
                  TextFormField(
                    controller: _con.factura_nombre_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'NOMBRE',
                      labelText: 'INGRESE RAZÓN SOCIAL',
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Menos espacio interno
                    ),
                    style: TextStyle(fontSize: 12), // Reducir tamaño de la fuente
                    validator: (value){   
                       String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");               
                      if (newValue?.length == 0) {
                            return 'Ingre razón social';
                      }
                      else if (newValue!.length<6) {
                            return 'Mínimo 5 caracteres';
                      }
                      else{
                        return null;
                      }
                  },
                 ),

                 */
                 SizedBox(height: 10),

                           TextFormFieldWidget(
                              controller: _con.factura_address_controller,
                              focusNode: _con.FacturaAddressNodeFocus,
                              labelText: 'INGRESE DIRECCIÓN FISCAL',
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                              maxLength: 150, // Puedes especificar la longitud máxima aquí
                              validator: (value) {
                                      String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");               
                                      if (newValue?.length == 0) {
                                            return 'Ingre Dirección fiscal';
                                      }
                                      else if (newValue!.length<6) {
                                            return 'Mínimo 5 caracteres';
                                      }
                                      else{
                                        return null;
                                      }
                              },
                            ),

                 /*
                  TextFormField(
                    controller: _con.factura_address_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'NOMBRE',
                      labelText: 'INGRESE DIRECCIÓN FISCAL',
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Menos espacio interno
                    ),
                    style: TextStyle(fontSize: 12), 
                    validator: (value){   
                       String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");               
                      if (newValue?.length == 0) {
                            return 'Ingre Dirección fiscal';
                      }
                      else if (newValue!.length<6) {
                            return 'Mínimo 5 caracteres';
                      }
                      else{
                        return null;
                      }
                  },
                 ),*/

      
        ],
      ),
    );
  }
  Widget _fom_boleta(){
    return  Form(
          key: _con.formkey,
      child: Column(
        children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinea el botón a la parte inferior
                    children: [
                      Expanded(
                        child:TextFormFieldWidget(
                              controller: _con.boleta_document_controller,
                              focusNode: _con.boletaDocumentNodeFocus,
                              labelText: 'INGRESE DNI',
                              keyboardType: TextInputType.number,
                              maxLength: 8, // Puedes especificar la longitud máxima aquí
                              validator: (value) {
                                    String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                                    RegExp regExp = new RegExp(pattern);
                                    String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                                    if (newValue?.length == 0) {
                                        return 'Ingre el número de DNI';
                                    }
                                    else if (newValue?.length != 8) {
                                          return 'Solo se permite 8 digitos';
                                    }
                                    else{
                                          return null;
                                    }
                              },
                            ), 
                        

                      ),
                      SizedBox(width: 8), // Espacio entre el TextFormField y el botón
                      ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                                _con.searchClient();
                            },
                            child: Icon(Icons.search), // Icono de búsqueda
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(10), // Ajusta el padding del botón
                              minimumSize: Size(40, 40), // Altura y ancho del botón
                              shape: CircleBorder(), // Hace el botón circular
                            ),
                      ),
                    ],
                  ),

                  /*TextFormField(
                     controller: _con.boleta_document_controller,
                     focusNode: _con.boletaDocumentNodeFocus,
                     maxLength: 8,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: 'DNI',
                      labelText: 'INGRESE DNI'
                    ),
                     validator: (value){
                    String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                    RegExp regExp = new RegExp(pattern);
                    String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                    if (newValue?.length == 0) {
                        return 'Ingre el número de DNI';
                    }
                    else if (newValue?.length != 8) {
                          return 'Solo se permite 8 digitos';
                    }
                    else{
                          return null;
                    }
                  },                   
                 ),
                 */
                 SizedBox(height: 10),
                  TextFormFieldWidget(
                              controller: _con.boleta_nombre_controller,
                              focusNode: _con.boletaNombreNodeFocus,
                              labelText: 'INGRESE NOMBRES',
                              keyboardType: TextInputType.text,
                              maxLength: 100, // Puedes especificar la longitud máxima aquí
                              validator: (value) {
                                      String newValue = value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "");               
                                      if (newValue?.length == 0) {
                                            return 'Ingre nombre de cliente';
                                      }
                                      else if (newValue!.length<3) {
                                            return 'Mínimo 3 caracteres';
                                      }
                                      else{
                                        return null;
                                      }
                              },
                            ),


      
        ],
      ),
    );
  }

  void refresh(){
    setState(() {
      
    });
  }
}