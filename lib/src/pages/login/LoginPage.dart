import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:villachicken/src/pages/login/LoginController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/text_form_field.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({ Key ? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con=new LoginController();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //print('inica primer init');
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        //print('inicia sheduler binding');
        _con.init(context);
      });
    }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SingleChildScrollView(
         child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -100,
                child:_circleLogin(),
                ),
              Positioned(
                top: 60,
                left: 25,
                child:_textlogin(),
                ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                child: Column(
                  
                  children: [
                    //_lottieanimacion(),  
                   
                    _logo(),    
                    _correo(),
                    SizedBox(height: 10,),
                    _password(),
                    SizedBox(height: 10,),
                    _button()
                  ],
                
                ),
              ),
            ],
          ),
        ),
        ),
    );
  }
  Widget _logo(){
      return              Container(
                      height: 250,
                     margin: EdgeInsets.only(top: 150,bottom: 20),
                      child: FadeInImage(
                        image: AssetImage('assets/img/login.png'), 
                        fit:BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      ),
                    );
  }
   Widget _circleLogin(){
   return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.secondaryColor
      ),
   );
 }
 Widget _textlogin(){
  return BigText(text: 'LOGIN', size: 22,color: Colors.white,);
   return Text('LOGIN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),);
 }
  Widget _correo(){
      return TextFormFieldWidget(
         controller: _con.emailcontroller,
         focusNode: _con.emailNodeFocus, 
         labelText: 'Correo electrónico',
         enabled: true,
         maxLines: 1,
         keyboardType: TextInputType.emailAddress, 
         maxLength: 30,
         //fontSize: 9,
         prefixIcon: Icon(Icons.email,color: MyColors.white),
         validator: (value){
                        String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value?.length == 0) {
                              return 'Ingre el numero de celular';
                        }
                        else if (!regExp.hasMatch(value.toString())) {
                          return 'Ingresa correctamente el número de celular';
                        }else{
                          return null;
                        }
         }
    );
    return   
            Container(
            
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
              decoration: BoxDecoration(
                color: MyColors.primaryopacitycolor,
                borderRadius: BorderRadius.circular(30)
              ),
              child: TextField(
                controller: _con.emailcontroller,
               keyboardType: TextInputType.emailAddress,
               decoration: InputDecoration(
                 hintText: 'Correo electronico',
                 border: InputBorder.none,
                 contentPadding: EdgeInsets.all(15),
                 hintStyle: TextStyle(color: MyColors.primarycolorDark),
                 prefixIcon: Icon(Icons.email,color: MyColors.primarycolor,)
               ),
               
                
              ),
            ) ;

  }

  Widget _password(){
      return TextFormFieldWidget(
         controller: _con.passwordcontroller,
         focusNode: _con.passwordNodeFocus, 
         labelText: 'Password',
         obscureText:true,
         enabled: true,
         maxLines: 1,
         keyboardType: TextInputType.emailAddress, 
         maxLength: 30,
         //fontSize: 9,
         prefixIcon: Icon(Icons.security,color: MyColors.white),
         validator: (value){
                        String pattern = r'(^(?:[+0]9)?[0-9]{9}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value?.length == 0) {
                              return 'Ingre el numero de celular';
                        }
                        else if (!regExp.hasMatch(value.toString())) {
                          return 'Ingresa correctamente el número de celular';
                        }else{
                          return null;
                        }
         }
    );

    return   
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              decoration: BoxDecoration(
                color: MyColors.primaryopacitycolor,
                borderRadius: BorderRadius.circular(30)
              ),
              child: TextField(
                controller: _con.passwordcontroller,
                obscureText: true,
               decoration: InputDecoration(
                 hintText: 'Password',
                 border: InputBorder.none,
                 contentPadding: EdgeInsets.all(15),
                 hintStyle: TextStyle(color: MyColors.primarycolorDark),
                 prefixIcon: Icon(Icons.email,color: MyColors.primarycolor,)
               ),
               
                
              ),
            ) ;
  }
  Widget _button(){
    return BigButtonWidget(text: 'INGRESA', onTap: (){_con.login();});
    return 
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
              child: ElevatedButton(
                onPressed: _con.login,
                child: Text('Ingresar'),
                style: ElevatedButton.styleFrom(
                  //primary: MyColors.primarycolor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20)
                ),
              ),
            );
  }
  Widget _lottieanimacion(){
    return Container(
      margin: EdgeInsets.only(
        top:156,
        bottom: MediaQuery.of(context).size.height*0.05
      ),

      child: Lottie.asset('assets/json/delivery2.json',
      width: 350,
      height: 200,
      fit: BoxFit.fill),
    );
  }

}