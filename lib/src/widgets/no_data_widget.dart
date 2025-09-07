// Statelesswidget nunca cambia de estado
// Statefulldigets si cambia
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/small_text.dart';

class NoDataWidget extends StatelessWidget {
  late String text;
  late String path;
  NoDataWidget({ Key ? key,required this.path,required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image.asset('assets/img/no_items.png'),
          Image.asset(path),
          BigText(text:text,size: 11,)
        ],
      ),
    );
  }
}