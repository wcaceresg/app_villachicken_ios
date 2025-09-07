import 'dart:async';

import 'package:flutter/material.dart';
import 'package:villachicken/src/widgets/loader.dart';

setTimeout(callback, time) {
  Duration timeDelay = Duration(milliseconds: time);
  return Timer(timeDelay, callback);
}
void onLoading(dialogContext,context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return LoaderWidget();
    },
  );
}