
import "package:flutter/material.dart";
import "package:villachicken/src/providers/client_provider.dart";
import "package:villachicken/src/utils/shared_pref.dart";

class ClientsTipoEfectivoController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 int counter=1;
 SharedPref _sharedPref=new SharedPref();
 ClientProvider clientProvider=new ClientProvider();
 List tipo_comprobante=[];
 int  tipo_comprobante_select=1;
 double monto=0.00;
TextEditingController montoController=new TextEditingController();
final FocusNode montoNodeFocus = FocusNode();
GlobalKey<FormState> formKey=new GlobalKey<FormState>();
late var client;
Future init(BuildContext context,Function refresh,data) async{
  this.context=context;
   this.refresh=refresh;
   tipo_comprobante=[
    {'id':1,'name':'PAGO EXACTO'},
    {'id':2,'name':'OTRO MONTO'},
   ];
   monto=data["monto"];
  refresh();
}
void register(){
      double paySoles=monto;
      double vuelto=0;
      if(tipo_comprobante_select==2){
        if(formKey.currentState!.validate()){
              paySoles=num.parse(montoController.text).toDouble();
              vuelto=paySoles-monto;
              vuelto=double.parse(vuelto.toStringAsFixed(2));
        }else{
          return;
        }
      }
      var datos={
          'payment_soles':paySoles,
          'payment_vuelto':vuelto,

      };

      Navigator.pop(context,datos);

}


 }