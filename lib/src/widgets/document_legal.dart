import 'package:flutter/material.dart';

class documentLegalWidget {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    VoidCallback? onComplete,
    Function? ondata
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      builder: (context) => child,
    ).whenComplete(() {
      if (onComplete != null) onComplete();
    }).then((value) => {if (ondata != null) ondata(value)});
  }
}