import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/pages/clients/documents/TypeDocumentController.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_button.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TypeDocumentPage extends StatefulWidget {
    final arguments;
    final String title;
  const TypeDocumentPage({super.key,@required this.arguments,this.title=''});

  @override
  State<TypeDocumentPage> createState() => _TypeDocumentPageState();
}
class _TypeDocumentPageState extends State<TypeDocumentPage> {
  TypeDocumentController _con=new TypeDocumentController();
  @override
  void initState(){
    super.initState();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context,refresh,widget.arguments);
      });
  }
  @override
  Widget build(BuildContext context) {
     return Container(
            height: MediaQuery.of(context).size.height * 0.9, 
            child: Scaffold(
            appBar:  AppBar(
          title: Text(widget.title,style: TextStyle(color: Colors.white,fontSize: 15),),
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.secondaryColor,
          actions: <Widget>[
               IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              
                onPressed: () {
                     _con.handle(false);
                },
              )
        ],
        ),
              body: WebViewWidget(controller: _con.controller,gestureRecognizers: _con.gestureRecognizers,),
              bottomNavigationBar:_ButtonBottom()
            ),
    );
  }
   Widget _ButtonBottom(){
    return Container(
        height: 100,
        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right:20),
        decoration: BoxDecoration(
        border: Border(
          top: BorderSide( //                   <--- left side
            color: Colors.black,
            width: 0.1,
          ),
        ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: BigButtonWidget(
                color: Colors.black26,
                  text: "Cerrar ",
                  onTap: () =>{_con.handle(false)},
                ),
             
            ),
             SizedBox(width: 10,),
            Flexible(
              child: BigButtonWidget(
                  text: "Aceptar ",
                  onTap: () =>{_con.handle(true)},
                ),
            )
          ],
        ),

      );
  }   
  void refresh(){
    setState(() {
      
    });
  }
  
  }