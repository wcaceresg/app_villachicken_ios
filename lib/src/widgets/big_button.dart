import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'big_text.dart';

class BigButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color colortext;
  final VoidCallback onTap;
  final double vertical;
  final double horizontal;
  final double size;
  final String fontFamily;
  final Widget? leading; // Admite imagen, ícono o cualquier otro widget

  const BigButtonWidget({
    Key? key,
    required this.text,
    this.color = MyColors.secondaryColor,
    this.colortext = Colors.white,
    required this.onTap,
    this.vertical = 0,
    this.horizontal = 0,
    this.size = 20,
    this.fontFamily = 'Subway',
    this.leading, // Propiedad opcional para la imagen o ícono
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Renderiza el `leading` solo si está definido
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8), // Espaciado entre imagen/ícono y texto
            ],
            BigText(
              text: text.toUpperCase(),
              color: colortext,
              size: size,
              fontFamily: fontFamily,
            ),
          ],
        ),
      ),
    );
  }
}