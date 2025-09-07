import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';
class GeneroFormWidget extends StatelessWidget {
  final String hintText;
  final int? currentSelectedValue;
  final List items;
  final ValueChanged<int?> onChanged;

  const GeneroFormWidget({
    Key? key,
    required this.hintText,
    required this.currentSelectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        color: MyColors.blackTextFild,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: DropdownButton<int>(
          icon: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_drop_down_circle),
          ),
          iconEnabledColor: Colors.white,
          hint: Text(
            hintText,
            style: TextStyle(color: MyColors.white.withOpacity(0.8)),
          ),
          style: TextStyle(color: MyColors.white.withOpacity(0.8)),
          dropdownColor: MyColors.black,
          value: currentSelectedValue,
          onChanged: onChanged,
          items: items.map((map) {
            return DropdownMenuItem<int>(
              child: Text(
                map["name"],
                style: TextStyle(color: MyColors.white),
              ),
              value: map["id"],
            );
          }).toList(),
        ),
      ),
    );
  }
}