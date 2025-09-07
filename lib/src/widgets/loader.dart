// Statelesswidget nunca cambia de estado
// Statefulldigets si cambia
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoaderWidget extends StatelessWidget {
  late String text;
  LoaderWidget({ Key ? key,text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left:20,right: 20),

          child: new Row(
            mainAxisSize: MainAxisSize.min,
            
            children: [
              new CircularProgressIndicator(),
              SizedBox(width: 20,),
              new Text("Cargando . . ."),
            ],
          ),
        ),
      );
  }
}