import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:villachicken/src/utils/my_colors.dart';
class BigText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  TextOverflow overFlow;
  int maxlines;
  TextAlign textAlign;
  String fontFamily;
  BigText({ Key  ?  key,
  this.color=const Color(0xFF332d2b),  
  this.size=20,
  required this.text,
  this.overFlow=TextOverflow.ellipsis,
  this.maxlines=1,
  this.textAlign=TextAlign.start,
  this.fontFamily='Subway'//Cassandra
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      overflow:overFlow,
      textAlign: textAlign, // Alinea el texto al centro
      style: TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: size,     
      ),
      
      
      
      
    );
  }
}