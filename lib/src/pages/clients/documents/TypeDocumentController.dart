import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TypeDocumentController{
  late BuildContext context;
   late Function refresh;
   late  WebViewController controller=new WebViewController();
    final ScrollController scroll = ScrollController();
    var data=1;
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
  Factory(() => EagerGestureRecognizer())
};
  Future init (BuildContext context,Function refresh,data) async{
    this.context=context;
    this.refresh=refresh;
     this.data=data;
     
    init_payment();

  }
  init_payment() async{
    String url=Environment.URL_DOCUMENT_TERMINOS;
    if(data==2){
      url=Environment.URL_DOCUMENT_PRIVACIDAD;
    }
    print(data);
    controller=WebViewController()..loadRequest(Uri.parse(url));
    controller..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
        },
        onPageFinished: (url) => {
                //injectJavascript(controller)
        }
      )
    )..setJavaScriptMode(JavaScriptMode.unrestricted);   
     refresh();
  }
  void handle(status){
      var datos={
          'status':status,
      };
      Navigator.pop(context,datos);
  }


}