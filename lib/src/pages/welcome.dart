import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/pages/welcome_controller.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({ Key  ? key }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}
class _WelcomePageState extends State<WelcomePage> {
  WelcomeController _con=new WelcomeController();
  @override
    void initState() {
      super.initState();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context);
      });
    }

  @override
  Widget build(BuildContext context) {
    return  Container(
  decoration: BoxDecoration(
    color: MyColors.secondaryColor
   /* image: DecorationImage(
      image: AssetImage("assets/img/red-cover.jpg"),
      fit: BoxFit.fill,
    ),
    */
  ),

      child: Scaffold(
         // backgroundColor: MyColors.primarycolor,
         backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
           child: Container(
            width: double.infinity,  
            child: Stack(            
              children: [
                Column(
                  
                  children: [
                     SizedBox(height: MediaQuery.of(context).size.height*0.35,),
                    _logo(),
                   // _button_facebook(),
                   _button_ios(),
                    SizedBox(height: 10,),
                    _button_gmail(),
                    SizedBox(height: 10,),
                    _button_email(),
                    _register()                      
                  ],
                ),           
              ],
            ),
          ),
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(right: 15,bottom: 10),
              child: Row(
                children: <Widget>[
                  Text(""),
                  Spacer(), // use Spacer
                  Text("Versión: ${Environment.version.toString()}",style: TextStyle(color:Colors.white,fontSize: 12),),
                ],
              ),
            ),
          ),),
    );
  }
   Widget _logo(){
           return           Container(
                            height: 130.0,
                            width: 130.0,
                            margin: EdgeInsets.only(bottom:30),
                           // padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            
                            color:Colors.white,

                              image: DecorationImage(
                                   
                                
                                image: AssetImage(
                                    'assets/img/villa2.jpg'),
                                //fit: BoxFit.fill,
                              ),
                            // shape: BoxShape.circle,
                            ),
                          );

   }
   Widget  _register(){
    return GestureDetector(
  onTap: () => {Navigator.pushNamed(context, 'register')},
  child: Container(
    margin: EdgeInsets.only(top: 10),
    child: Column(
      children: [
        // Texto
        Text(
          'REGISTRATE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            decoration: TextDecoration.none, // Sin subrayado
            fontFamily: 'Glacial'
          ),
        ),
        // Línea simulando el subrayado
        Container(
          height: 1, // Grosor del subrayado
          width: 50, // Ancho de la línea
          color: Colors.white, // Color del subrayado
          margin: EdgeInsets.only(top: 2), // Espaciado para bajar la línea
        ),
      ],
    ),
  ),
);
   }
   Widget _circleLogin(){
   return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primarycolor
      ),
   );
 }
 Widget _textlogin(){
   return Text('LOGIN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),);
 }


  Widget _button_facebook(){
    return BigButtonWidget(text: 'INGRESA CON TU FACEBOOK', onTap:(){},color: Colors.blue.shade900,horizontal: 80,size: 12,fontFamily: 'Glacial',);
  
  }
  Widget _button_ios(){
    return BigButtonWidget(text: 'Iniciar Sesión son Apple', 
    leading: Image.asset(
    'assets/img/apple_icon.png',
    width:24,
    height: 24,
    color: Colors.white,
    
  ),
    onTap:(){

      _con.HandleLoginApple();
    },color: Colors.black,horizontal: 80,size: 12,fontFamily: 'Glacial',);
  
  }

  Widget _button_gmail(){
      return BigButtonWidget(text: 'INGRESA CON TU GOOGLE',        leading: Image.asset(
    'assets/img/google.png',
    width:24,
    height: 24,
  ),onTap:(){_con.requestLogin();},color: Colors.white,horizontal: 80,size: 12,fontFamily: 'Glacial',colortext: MyColors.secondaryColor,);
  }

  Widget _button_email(){
    return BigButtonWidget(text: 'INGRESA CON TU EMAIL',
 leading: Icon(
     Icons.email,
    color: Colors.white,
    size: 24,
  ),   
     onTap:(){_con.goToLoginEmail();},color: MyColors.yellowcolor,horizontal: 80,size: 12,fontFamily: 'Glacial',colortext: MyColors.secondaryColor,);
    return 
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 80,vertical: 5),
              child: ElevatedButton(
                onPressed: _con.goToLoginEmail,
               // onPressed: (){},
                child: Text('Ingresar con Correo',style: TextStyle(fontSize: 12),),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.yellow.shade700,
                  shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10)
                ),
              ),
            );
  }
}