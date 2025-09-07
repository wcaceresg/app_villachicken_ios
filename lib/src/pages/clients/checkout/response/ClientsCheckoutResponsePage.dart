import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/checkout/response/ClientsCheckoutResponseController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/small_text.dart';

class ClientsCheckoutResponsePage extends StatefulWidget {
  const ClientsCheckoutResponsePage({super.key});

  @override
  State<ClientsCheckoutResponsePage> createState() => _ClientsCheckoutResponsePageState();
}

class _ClientsCheckoutResponsePageState extends State<ClientsCheckoutResponsePage> {
 ClientsCheckoutResponseContnroller _con=new ClientsCheckoutResponseContnroller();
  @override
  void initState(){
    super.initState();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
         final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        _con.init(context, refresh);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _con.response["status"]!=null?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.check_circle, color: Colors.green, size: 60),
                    _con.response["status"]==1?Container(
                      height: 250,
                      margin: EdgeInsets.only(top: 10),
                      child: FadeInImage(
                        image: AssetImage('assets/img/villy_disfruta.png'),
                        fit:BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      ),
                    ):Container(),
                    //SizedBox(height: 5),
                    Container(
                      height: 150,
                      margin: EdgeInsets.only(top: 10),
                      child: FadeInImage(
                        image: _con.response["status"]==1?AssetImage('assets/img/success3.png'):AssetImage('assets/img/failed.png'), 
                        fit:BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: BigText(text: '${_con.response["message"].toUpperCase()}',size: 18,maxlines: 4,textAlign: TextAlign.center,),
                    ),
                    
                    Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: ()=>{_con.ValidatePayment()},
                      style: ElevatedButton.styleFrom(
                        //primary:  _con.response["status"]==1?MyColors.black :MyColors.primarycolor, // Color de fondo
                        //onPrimary: Colors.white, // Color del texto
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Espaciado
                        textStyle: TextStyle(fontSize: 20), // Estilo del texto
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Bordes redondeados
                        ),
                      ),
                      child: Text('ACEPTAR'),
                    ),
                  ),



                  ],
                ),
              ),
            ),


        ],
      ):Container(),
    );
  }
  void refresh(){
    setState(() {
      
    });
  }
}