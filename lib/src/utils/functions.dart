import 'dart:ffi';

import 'package:villachicken/src/utils/shared_pref.dart';

class FunctionsUtil{
   List carrito=[];
   SharedPref _sharedPref=new SharedPref();
   double recargo=0.00;
   FunctionsUtil(this.recargo);
   double getDcto(carrito) {
    double descuento=0.00;
    if(carrito.length>0 ){
      carrito.forEach((element) {
         descuento+=num.parse(element["descuento"].toString()).toDouble();
        
      });
    }
    return double.parse(descuento.toStringAsFixed(2));
  }
  double getSubTotal(carrito){
    double products = 0.00;
    if (carrito.isNotEmpty) {
      // print("cantidad carrito ${carrito.length}");
      carrito.forEach((element) {
        double precioUnitario = num.parse(element["pu"].toString()).toDouble();
        int cantidad = num.parse(element["cantidad"].toString()).toInt();
        //print("Precio unitario ${precioUnitario}");
        //print("Cantidad ${cantidad}");
        //print("Decuento ${element["descuento"]}");
        products += precioUnitario * cantidad;
      });
    }
    return double.parse(products.toStringAsFixed(2));
  }

  double getTotal(carrito){
    double total=0.00;
    double products = getSubTotal(carrito);

    //print("Subtotal: $products");
    double descuento = getDcto(carrito);
    //print("Descuento: $descuento");
    //double recargo=getRecargo();
    // Validar descuento y calcular total
    total = (products + recargo) - (descuento ?? 0.0);
    //print("Total****: $total");

    return double.parse(total.toStringAsFixed(2));
  }

  
}