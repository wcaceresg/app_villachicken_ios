import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/checkout/efectivo/ClientsTipoEfectivoController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/text_form_field.dart';

class ClientsTipoEfectivoPage extends StatefulWidget {
  final arguments;
  const ClientsTipoEfectivoPage({super.key,@required this.arguments});
  @override
  State<ClientsTipoEfectivoPage> createState() => _ClientsTipoEfectivoPageState();
}

class _ClientsTipoEfectivoPageState extends State<ClientsTipoEfectivoPage> {
  ClientsTipoEfectivoController _con=new ClientsTipoEfectivoController();
  @override
    void initState() {
      super.initState();
       SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          _con.init(context,refresh,widget.arguments);
       });

    }

  @override
  Widget build(BuildContext context) {
    return Container(
       height: MediaQuery.of(context).size.height*0.4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ingresa el monto con el que se pagará  S/ ${_con.monto.toString()}',style: TextStyle(color: Colors.white,fontSize: 13),),
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
                typePayment(),
                _con.tipo_comprobante_select==2?_form_monto():Container(),
                SizedBox(height: 15),
                BigButtonWidget(text: 'Siguiente', onTap: ()=>{_con.register()})
               ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _form_monto(){
    return  Form(
          key: _con.formKey,
      child: Column(
        children: [
                 SizedBox(height: 10),
                           TextFormFieldWidget(
                              controller: _con.montoController,
                              focusNode: _con.montoNodeFocus,
                              labelText: 'INGRESE MONTO',
                              //keyboardType: TextInputType.numberWithOptions(decimal: true),
                              keyboardType: TextInputType.numberWithOptions(decimal: false), 


                              validator: (value) {
                                  String newValue = value!.replaceAll(RegExp(r"\s+\b|\b\s"), ""); // Eliminar espacios

                                      if (newValue.isEmpty) {
                                        return 'Ingrese un monto';
                                      }/* else if (!RegExp(r'^\d*\.?\d*$').hasMatch(newValue)) {
                                        return 'Solo se permiten números decimales';
                                      } else if (double.tryParse(newValue) == null) {
                                        return 'Número inválido';
                                    
                                      }
                                      */ 
                                       else if (int.tryParse(newValue) == null) {
                                        return 'Número inválido';
                                      }                                      
                                      else if (double.parse(newValue) < _con.monto) {
                                          return 'El monto debe ser menor o igual a ${_con.monto.toString()}';
                                      }
                                       else {
                                        return null;
                                      }
                              },
                            ),


      
        ],
      ),
    );
  }
  Widget typePayment(){
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
                                                              Text(''+_con.tipo_comprobante[index]['name']),
                                                              Radio(
                                                                value: _con.tipo_comprobante[index]['id'], 
                                                                groupValue: _con.tipo_comprobante_select, 
                                                                onChanged: (index2) {
                                                                setState(() {  
                                                                  _con.tipo_comprobante_select = index2; 
                                                                 // _con.typeDocumentChange();                                                                   
                                                                });  
                                                                },
                                                                activeColor: MyColors.primarycolor,
                                                                ),
                                                            ],
                                                          );
                                              })
              
                                          );
  }
  void refresh(){
    setState(() {
      
    });
  }
}