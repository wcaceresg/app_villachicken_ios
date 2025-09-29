import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:villachicken/src/providers/user_provider.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/utils/shared_pref.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key ? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  SplashController _con=new SplashController();
  int _start = 5;

  @override
  void initState(){
    super.initState();

      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        print('inicia sheduler binding');
        _con.init(context);
      });

    controller=new AnimationController(
      vsync:this,
      duration: Duration(seconds: 1))..forward();
      
      animation=CurvedAnimation(parent: controller, curve: Curves.linear);

       Timer.periodic(const Duration(seconds: 1), (Timer timer) {
            if (_start == 0) {
              _con.ok();
              setState(() {
                
                timer.cancel();
              });
            } else {
              //print('aun no');
              setState(() {
                _start--;
              });
            }
      });
      
      

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(child: Image.asset('assets/img/villa_logo1.png',width: 200,)))
        ],
      ),
      
    );
  }
    void refresh(){
    setState(() {
      
      //print('se ha reelogeado');
      
      
       });
      
  }  
}


class SplashController{
late BuildContext context;
UserProvider userprovider=new UserProvider();
SharedPref _sharedPref=new SharedPref(); 
var user_type;
Future init(BuildContext context) async{
  this.context=context;
  user_type=await _sharedPref.read('user-type');
}
void ok() async{
  if(await _sharedPref.contains('user')){
    try{
      if(user_type=="guest"){
        Navigator.pushNamedAndRemoveUntil(context, 'client/main', (route) => false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
      }
     
    }catch(e){
       Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }

  }else{
      Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);

  }
   
   
}
}