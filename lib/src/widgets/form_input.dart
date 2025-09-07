import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';
class FormInput extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  double height;
  TextOverflow overFlow;
  int maxlines;
  TextAlign textAlign;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final Widget prefixIcon; 
  final Function()? onTap; 
  bool readOnly;
  bool obscureText;
  FormInput({ Key  ?  key,
  this.color=const Color(0xFF332d2b),  
  this.size=21,
  this.height=45,
  required this.text,
  this.overFlow=TextOverflow.ellipsis,
  this.maxlines=1,
  this.textAlign=TextAlign.start,
  required this.textInputType,
  required this.textEditingController,
  required this.prefixIcon,
  this.onTap,
  this.readOnly=false,
  this.obscureText=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
    padding: EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: MyColors.blackBG,
      borderRadius: BorderRadius.circular(20.0),
    ),
    alignment: Alignment.center,
    child: SizedBox(
      height: height, 
      child: TextField(
        style: TextStyle(color: MyColors.white.withOpacity(0.8)),
        controller: textEditingController,
        obscureText: obscureText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: '${this.text}',
          border: InputBorder.none,
          hintStyle: TextStyle(color: MyColors.white.withOpacity(0.4)),
          prefixIcon: prefixIcon, 
        ),
        readOnly: readOnly,
        onTap: () {
        if (onTap != null) {
          onTap!(); 
          }
        },

      ),
    ),
  );
  }
}