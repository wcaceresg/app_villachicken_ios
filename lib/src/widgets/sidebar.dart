// Statelesswidget nunca cambia de estado
// Statefulldigets si cambia
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:villachicken/src/models/user.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
import 'package:villachicken/src/widgets/big_text.dart';

class SideBarWidget extends StatelessWidget {
  late String text;
  SideBarWidget({ Key ? key,text }) : super(key: key);
  late BuildContext _context;
  SharedPref _sharedPref=new SharedPref();
  late String nombre;
  var user;
  var user_type;
   Future<User> fetchData() async {
     final user=User.fromJson(await _sharedPref.read('user') ?? {});
     user_type=await _sharedPref.read('user-type');
     return user;
  }

  

  

  @override
  Widget build(BuildContext context)  {
    _context=context;
   
     return  Container(
        child: FutureBuilder<User>(
          future: fetchData(),  // Llama a la función asíncrona
          builder: (context, snapshot) {
            // Verifica el estado de la conexión
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();  // Muestra un indicador de carga mientras se espera
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');  // Muestra un mensaje de error si lo hay
            } else {
             // return Text('Resultado: ${snapshot.data!.user.nombres}');  // Muestra los datos obtenidos
              return Drawer(
                    child:Container(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: MyColors.secondaryColor
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                              BigText(text:  '${snapshot.data!.user.nombres}',size: 18,maxlines: 2,color: Colors.white,),
                              Text(
                                '${snapshot.data!.user.email}',
                                
                                style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic
                                ),
                                maxLines: 1,
                              ),                           
                              Center(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.only(top: 10),
                                  child: FadeInImage(
                                    image: AssetImage('assets/img/villa_moto.png'), 
                                    fit:BoxFit.contain,
                                    fadeInDuration: Duration(milliseconds: 50),
                                    placeholder: AssetImage('assets/img/villa_moto.png'),
                                  ),
                                ),
                              )
                      
                            ],
                          )),
                          user_type=="guest"?Container(): ListTile(
                            title: Text('Inicio'),
                            trailing: Icon(Icons.home),
                            onTap: ()=>{gotohome()},
                            //leading: Icon(Icons.cancel),
                          ),
                          ListTile(
                            title: Text('Carta'),
                            trailing: Icon(Icons.food_bank),
                            onTap: ()=>{gotoCarta()},
                            //leading: Icon(Icons.cancel),
                          ),

                          user_type!="guest"? ListTile(
                            title: Text('Mi perfil'),
                            trailing: Icon(Icons.person),
                            //leading: Icon(Icons.cancel),
                      
                          ):Container(),
                          user_type!="guest"? ListTile(
                            title: Text('Mis pedidos'),
                            trailing: Icon(Icons.menu),
                            onTap: ()=>{goToPedidos()},
                          
                          ):Container(),
                          user_type!="guest"? ListTile(
                            title: Text('Mis direcciones'),
                            trailing: Icon(Icons.location_on),
                            onTap: ()=>{gotoaddress()},
                          
                          ):Container(),               
                          ListTile(
                            title: Text('Cerrar Sesion'),
                            trailing: Icon(Icons.exit_to_app),
                            onTap: ()=>{logout()},
                          
                          ),
                        ],
                      
                      ),
                    )
                  );

            }
          },
        ),
      );

    
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
   Navigator.of(_context).pushNamedAndRemoveUntil('client/home',(route)=>false);
  }
  void gotoCarta(){
   Navigator.of(_context).pushNamedAndRemoveUntil('client/main',(route)=>false);
  }
  void goToPedidos(){
   Navigator.of(_context).pop();
   Navigator.of(_context).pushNamed('client/orders');
  }

}