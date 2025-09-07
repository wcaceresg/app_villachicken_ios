import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:villachicken/src/api/envioroment.dart';
import 'package:villachicken/src/pages/clients/checkout/pasarela/ClientsCheckoutPasarelaController.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClientsCheckoutPasarelaPage extends StatefulWidget {
  const ClientsCheckoutPasarelaPage({super.key});

  @override
  State<ClientsCheckoutPasarelaPage> createState() => _ClientsCheckoutPasarelaPageState();
}

class _ClientsCheckoutPasarelaPageState extends State<ClientsCheckoutPasarelaPage> {
 //late final WebViewController _controller;
 ClientCheckOutPasarelaController _con=new ClientCheckOutPasarelaController();
  @override
  void initState(){
    super.initState();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
         final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        _con.init(context, refresh);
      });

    /*_controller=WebViewController()..loadRequest(Uri.parse(Environment.URL_PAYMENT));
    _controller..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
          setState(() {
            //print('ok');
          });
        },
        onPageFinished: (url) => {
                injectJavascript(_controller)
        }
      )

    )..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel("ResponseTransaction", onMessageReceived: (JavaScriptMessage message)
    {_con.store(message.message);
    });
    */
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       //height: MediaQuery.of(context).size.height*0.90,
      child: Scaffold(
        appBar: AppBar(
          title: BigText(text:"Pagar",size: 17)
        ),
        body: WebViewWidget(controller: _con.controller),
      ),
    );
  }

/*injectJavascript(WebViewController controller) async {
    controller.runJavaScript('''
       var checkbox = document.getElementById("checkbox_terminos");
        checkbox.addEventListener('change', function() {
          if (this.checked) {
            pagar("001", 5, "456879852", "192.168.1.100", "desarolloapp@gmail.COM", 0)
          } else {
           // alert('no check');
          }
        });
''');
  }
  */
  void refresh(){
    setState(() {
      
    });
  }

}