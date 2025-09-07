import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';
class DocumentCheckWidget extends StatefulWidget {
  final bool initialValue;
  final Function onTapTerms;
  final String title;
  final String subtitle;
  final Function(bool) onChanged;

  const DocumentCheckWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.initialValue = false,
    required this.onTapTerms,
    required this.onChanged,
  }) : super(key: key);

  @override
  DocumentCheckWidgetState createState() => DocumentCheckWidgetState();
}

class DocumentCheckWidgetState extends State<DocumentCheckWidget> {
  late bool checkvalue;

  @override
  void initState() {
    super.initState();
    checkvalue = widget.initialValue; // Inicializa el estado del checkbox con el valor pasado
  }

  // Método para cambiar el valor del checkbox manualmente
  void setCheckValue(bool value) {
    setState(() {
      checkvalue = value;
    });
    widget.onChanged(checkvalue); // Notifica al padre el cambio
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.white),
        child: Row(
          children: [
            Checkbox(
              value: checkvalue,
              onChanged: (newValue) {
                setState(() {
                  checkvalue = newValue ?? false; // Cambia el valor del checkbox
                });
                widget.onChanged(checkvalue); // Notifica al padre
              },
            ),
            Container(
              child: Text(
                widget.title, // Usa el título pasado en el constructor
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 2),
            GestureDetector(
              onTap: () => widget.onTapTerms(), // Ejecuta la función pasada cuando se tocan los términos
              child: Container(
                child: Text(
                  widget.subtitle,
                  style: TextStyle(color: MyColors.secondaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
