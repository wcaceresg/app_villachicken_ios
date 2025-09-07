import 'dart:io';

import 'package:flutter/material.dart';
import 'package:villachicken/src/pages/clients/address/create/clients_address_create_page.dart';
import 'package:villachicken/src/pages/clients/address/list/clients_address_page.dart';
import 'package:villachicken/src/pages/clients/address/map/cliente_address_map_page.dart';
import 'package:villachicken/src/pages/clients/address/welcome/clients_address_welcome_page.dart';
import 'package:villachicken/src/pages/clients/checkout/ClientsCheckoutPage.dart';
import 'package:villachicken/src/pages/clients/checkout/pasarela/ClientsCheckoutPasarelaPage.dart';
import 'package:villachicken/src/pages/clients/checkout/response/ClientsCheckoutResponsePage.dart';
import 'package:villachicken/src/pages/clients/favorites/ClientsFavoritesPage.dart';
//import 'package:villachicken/src/pages/clients/address/map/clients_address_map_page.backup';
import 'package:villachicken/src/pages/clients/main/ClientsMainPage.dart';
import 'package:villachicken/src/pages/clients/orders/ClientsOrdersListPage.dart';
import 'package:villachicken/src/pages/clients/pedidos/ClientsPedidoController.dart';
import 'package:villachicken/src/pages/clients/pedidos/ClientsPedidosPage.dart';
import 'package:villachicken/src/pages/clients/products/details/ClientsProductsDetailsPage.dart';
import 'package:villachicken/src/pages/clients/products/details/testpage.dart';
import 'package:villachicken/src/pages/login/LoginPage.dart';
import 'package:villachicken/src/pages/register/RegisterPage.dart';
import 'package:villachicken/src/pages/splash_creen.dart';
import 'package:villachicken/src/pages/welcome.dart';
import 'package:version_check/version_check.dart';
void main() {
  HttpOverrides.global=MyHttpOverrides();
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page in windsuef'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*String? version = '';
  String? storeVersion = '';
  String? storeUrl = '';
  String? packageName = '';

  final versionCheck = VersionCheck(
    packageName: Platform.isIOS ? 'com.tachyonfactory.iconFinder' : 'com.grupokong.villachicken',
    packageVersion: '1.05',
    showUpdateDialog: customShowUpdateDialog,
    country: 'pe',
  );
  Future<void> checkVersion() async {
    await versionCheck.checkVersion(context);

    setState(() {
      version = versionCheck.packageVersion;
      packageName = versionCheck.packageName;
      storeVersion = versionCheck.storeVersion;
      storeUrl = versionCheck.storeUrl;
    });
  }
    @override
  void initState() {
    super.initState();
    checkVersion();
  }*/
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Villa App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      //home: SplashScreen(),
      routes:{
        'splash_screen':(BuildContext context) =>SplashScreen(),
        'welcome':(BuildContext context) =>WelcomePage(),
        'login':(BuildContext context) =>LoginPage(),
        'register':(BuildContext context) =>RegisterPage(),
        'client/home':(BuildContext context) =>ClientsAddressWelcomePage(),
        'client/main':(BuildContext context) =>ClientsMainPage(),
        //'client/product_details':(BuildContext context) =>ClientProductDet(),
        'client/product_details':(BuildContext context) =>ClientsProductDetailPage(),
        'client/list_carrito':(BuildContext context) =>ClientOrderListPage(),
        'client/favorites':(BuildContext context) => ClientsFavoritesPage(),
        'client/address':(BuildContext context) =>ClientsAddressListPage(),
        'client/address/map':(BuildContext context) => ClientAddressMapPage(),
        'client/address/create':(BuildContext context) => ClientsAddressCreatePage(),
        'client/checkout':(BuildContext context) =>ClientsCheckoutPage(),
        'client/orders':(BuildContext context) => ClientspedidosPage(),
        'client/checkout/pasarela':(BuildContext context) => ClientsCheckoutPasarelaPage(),
        'client/checkout/response':(BuildContext context) => ClientsCheckoutResponsePage(),
       
      },
      theme: ThemeData(
       // primaryColor: Colors.deepOrangep
       primaryColor: Colors.orange,
       appBarTheme: AppBarTheme(elevation: 0)// sombra en el appbar
      ),

    );

  } 

 }
void customShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('NEW Update Available'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Do you REALLY want to update to ${versionCheck.storeVersion}?',
              ),
              Text('(current version ${versionCheck.packageVersion})'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              await versionCheck.launchStore();
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  }