import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';


class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLength; // Añadido el parámetro maxLength
  final int maxLines;
  final Icon? prefixIcon; // Hacer que el icono sea opcional
  final double fontSize;
  final bool enabled;
  final Function()? onTap; 
  final bool obscureText;
  const TextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    this.maxLength = 11, // Valor por defecto para maxLength
    this.maxLines=1,
    this.prefixIcon,
    this.fontSize=14,
    this.enabled=true,
    this.onTap,
    this.obscureText=false
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
      child: TextFormField(
        controller: controller,
         obscureText: obscureText,
        focusNode: focusNode,
        maxLength: maxLength, // Limita a la longitud máxima definida
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled:enabled,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
            borderSide: BorderSide(color: MyColors.white), // Color del borde
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyColors.black), // Color del borde cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: MyColors.black, width: 2), // Color del borde cuando está enfocado
          ),
         // labelText: labelText,
          hintText:labelText,
          hintStyle:TextStyle(color: MyColors.white), // Color de la etiqueta
          labelStyle: TextStyle(color: MyColors.white), // Color de la etiqueta
          floatingLabelStyle: TextStyle(
            color: MyColors.black, // Color de la etiqueta cuando está en foco
             fontSize: 15, // Ajusta el tamaño de fuente
             fontWeight:FontWeight.bold
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never, // Comportamiento de la etiqueta
          //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Espacio interno
          contentPadding: EdgeInsets.all(15),
          filled: true,
          fillColor: MyColors.blackTextFild, // Color de fondo
          counterText: '', // Elimina el contador de caracteres
          prefixIcon: prefixIcon, // Solo se muestra si prefixIcon no es null
        ),
        style: TextStyle(fontSize: fontSize, color: Colors.white), // Tamaño y color de fuente
        validator: validator, // Usamos el validador dinámico
        onTap: () {
        if (onTap != null) {
          onTap!(); 
          }
        },

      ),
    );
  }
}