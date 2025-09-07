import 'package:flutter/material.dart';
import 'package:villachicken/src/widgets/big_text.dart';

// Define el widget reutilizable para la lista del carrito
class CartListWidget extends StatelessWidget {
  final List cartItems;
  final Function(int) onQuantityChange;
  final Function(int) onQuantityRest;
  final Function(int) onRemoveItem;

  const CartListWidget({
    Key? key,
    required this.cartItems,
    required this.onQuantityChange,
    required this.onQuantityRest,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartItems.length > 0 ? cartItems.length : 0,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: cartItems[index]["imagen"] != null
                                ? NetworkImage(cartItems[index]["imagen"])
                                : AssetImage('assets/img/no-image.png') as ImageProvider,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                cartItems[index]["producto"] ?? "",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Subway',
                                ),
                              ),
                              Text(
                                cartItems[index]["combinacion"] ?? "",
                                style: TextStyle(
                                  color: Color(0xFFccc7c5),
                                  fontSize: 9,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  buildQuantityControl(index), // Función para controlar la cantidad
                                  if (double.parse(cartItems[index]["descuento"].toString() ?? "0") > 0)
                                    Text(
                                      'S/ ' + cartItems[index]["precio_tienda"].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  BigText(
                                    text: 'S/ ' + (double.parse(cartItems[index]["precio"].toString())-double.parse(cartItems[index]["descuento"].toString()) ).toString(),
                                    //text: 'S/ ' + (double.parse(cartItems[index]["precio"].toString())).toString(),
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildRemoveButton(index), // Botón para eliminar el ítem
                    ],
                  ),
                ),
                if (cartItems[index]["isfree"] == 1)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(Icons.card_giftcard, color: Colors.orange),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Función para controlar la cantidad
  Widget buildQuantityControl(int index) {
    return Row(
      children: [
        cartItems[index]["isfree"] !=1?_buildQuantityButton(Icons.remove, () => onQuantityRest(index)):Container(),
        const SizedBox(width: 5),
        Text(
          cartItems[index]["cantidad"].toString(),
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 5),
        cartItems[index]["isfree"] !=1?_buildQuantityButton(Icons.add, () => onQuantityChange(index)):Container(),
      ],
    );
  }

  // Botón para modificar la cantidad
  Widget _buildQuantityButton(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Icon(icon, color: Colors.grey, size: 18),
        ),
      ),
    );
  }

  // Función para eliminar el ítem
  Widget buildRemoveButton(int index) {
    return cartItems[index]["isfree"] == 0
        ? Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 5, right: 5),
            width: 25,
            child: GestureDetector(
              onTap: () => onRemoveItem(index),
              child: Icon(Icons.close, color: Colors.black, size: 18),
            ),
          )
        : Container(width: 25);
  }
}
