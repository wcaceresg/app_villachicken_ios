
import 'package:flutter/material.dart';
import 'package:villachicken/src/providers/order_provider.dart';
import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/loader.dart';

class ClientsPedidoController{
 late BuildContext context;
 late BuildContext dialogContext;
 late Function refresh;
 SharedPref _sharedPref=new SharedPref();
 List carrito_session=[];
 OrderProvider orderProvider=new OrderProvider();
 UserProvider userprovider=new UserProvider();
 bool enabled=true;
 List orders=[];
 GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();
 Future init(BuildContext context,Function refresh) async{
   this.context=context;
   this.refresh=refresh;
     try 
     {
      await userprovider.init(context,await _sharedPref.read('user') ?? {}) ;
      await orderProvider.init(context,await _sharedPref.read('user') ?? {}) ;
     } 
     catch (e) {
      print('Error al iniciar el servicio de pedidos: $e');
     }
    _onLoading();
      try 
      {
          await userprovider.reload_token();
      } catch (e) {
        
      }
     final data=await orderProvider.ListOrders();
     Navigator.pop(dialogContext);
    if(data['code']==400){
          if(data['error'].contains('Nuestro horario')!=false){
            //mySnackbar.show(context, data['error']);
            //dialog(data['error']);
          }
    }else{
      orders=data['data'];
    }

    print('order list2222');
    print(orders);
    refresh();

 }

 void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return LoaderWidget();
    },
  );
}
  void openDrawer(){
     key.currentState?.openDrawer();
     print("abierto");
  }
}