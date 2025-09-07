import 'package:flutter/material.dart';
import 'package:villachicken/src/utils/my_colors.dart';
import 'package:villachicken/src/widgets/big_text.dart';
import 'package:villachicken/src/widgets/small_text.dart';

// Widget que muestra el resumen de la orden
class ProductsResumeWidget extends StatelessWidget {
  final String title;
  final List cartItems; // Lista de productos en el carrito

  const ProductsResumeWidget({
    Key? key,
    required this.title,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),  // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),  // Sombra suave
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),  // Desplazamiento de sombra
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 20),  // Espaciado fijo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           Icon(Icons.edit_document, color: MyColors.secondaryColor),  // Ícono con color resaltado
                          const SizedBox(width: 10),  // Espacio entre el ícono y el texto
                          BigText(
                            text: '2. RESUMEN DE TU ORDEN',
                            size: 12,
                            //fontWeight: FontWeight.bold,  // Texto en negrita para jerarquía
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),  // Espacio entre el título y la lista
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartItems.length, // Longitud de la lista del carrito
                        itemBuilder: (BuildContext context, int index) {
                          final item = cartItems[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Imagen del producto
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: item["imagen"] != null
                                        ? NetworkImage(item["imagen"])
                                        : const AssetImage('assets/img/no-image.png') as ImageProvider,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),  // Separador de espacios
                              // Cantidad de producto
                              SmallText(
                                text:'${item["cantidad"]} x',
                                size:13
                              ),
                              const SizedBox(width: 10),
                              // Descripción del producto
                              Expanded(
                                child: SmallText(
                                  text:item["producto"],
                                 
                                    size: 13,
                                    color: Colors.black87,
                                 
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Precio del producto
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: BigText(
                                  text:'S/ ${item["precio"]}',
                                 
                                    size: 14,
                                    color: Colors.black,
                                 
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
