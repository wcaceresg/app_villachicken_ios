// Statelesswidget nunca cambia de estado
// Statefulldigets si cambia
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:villachicken/src/widgets/big_text.dart';

class TitleCarruselWidget extends StatelessWidget {
  final String text;
  TitleCarruselWidget({ Key ? key,required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       //margin: EdgeInsets.only(left: 30),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           BigText(text: "$text",fontFamily: 'Subway',size: 18,),
           SizedBox(width: 10,),
           Container(
             margin: const EdgeInsets.only(bottom: 3),
             //child: BigText(text: '.',color: Colors.black26,),
           ),
           SizedBox(width: 10,),
           Container(
             margin: const EdgeInsets.only(bottom: 2),
             //child: SmallText(text: "sss",),
           )
           

         ],

       ),
    );
  }
}