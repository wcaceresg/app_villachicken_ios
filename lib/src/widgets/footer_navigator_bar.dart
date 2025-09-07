// Statelesswidget nunca cambia de estado
// StatefulWidget  si cambia
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/utils/shared_pref.dart';

class FooterNavigatorWidget extends StatefulWidget {
  const FooterNavigatorWidget({ Key ?key }) : super(key: key);
  @override
  State<FooterNavigatorWidget> createState() => _FooterNavigatorState();
}
class _FooterNavigatorState extends   State<FooterNavigatorWidget>   {
  late String text;
  //FooterNavigatorWidget({ Key ? key,text }) : super(key: key);
  late BuildContext _context;
  SharedPref _sharedPref=new SharedPref();
  List carrito_sesion=[];
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    print('inica primer init');
      //imageCache.clear();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
       // _con.init(context,refresh);
       // imageCache.clear();
        _context=context;
       calculateListCarrito();
       print('inica primer init');
      });
    }
  
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.black, // <-- This works for fixed
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: (value) => {NavigatorGoTo(value)},
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
                icon: carrito_sesion.length>0?Badge(
                label: Text(carrito_sesion.length.toString()),
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
  void refresh(){
    setState(() {
      
    });
  }
  void calculateListCarrito() async{
  if(await _sharedPref.contains('order')){
        carrito_sesion=await _sharedPref.read('order');
        //print(data.length);
        //print(data[0]["producto"]);
        //print(carrito_sesion[4]);
        //refresh();
        
    }

 }
  void gotoWelcome(){
   Navigator.of(_context).pop();
   Navigator.of(_context).pushNamed('client/home');
  }
  void gototest(){
    Navigator.of(_context).pushNamed('test');
  }
  void logout(){
   _sharedPref.logout(_context);
  }
  void gotoaddress(){
   Navigator.of(_context).pop();
   Navigator.of(_context).pushNamed('client/address');
  }
  void gotohome(){
   Navigator.of(_context).pushNamedAndRemoveUntil('client/main',(route)=>false);
  }
  void NavigatorGoTo(int val){
      print(val);
      if(val==1){
            //Scrolldo(0);
      }
      else if(val==2){
        Navigator.of(_context).pushNamed('client/list_carrito');
      }else if (val==3){
        Navigator.of(_context).pushNamed('client/favorites');
      }
      else{
        
      }
  }
}