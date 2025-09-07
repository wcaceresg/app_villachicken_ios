import 'package:flutter/cupertino.dart';
import 'package:villachicken/src/utils/my_colors.dart';
class SmallText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  double height;
  String fontFamily;
  SmallText({ Key? key,
  this.color=const Color(0xFFccc7c5),  
  this.size=12,
  this.height=1.2,
  required this.text,
  this.fontFamily='Roboto'
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size,
        height: height
      ),
      
    );
  }
}