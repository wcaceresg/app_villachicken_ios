import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:villachicken/src/widgets/big_text.dart';

// Define el widget reutilizable
class SugestiveCardWidget extends StatelessWidget {
  final List sugestiveList; // Lista de productos sugeridos
  final Function(int) onTap; // Callback para manejar el evento onTap
  final int currentIndex; // Índice actual del PageView
  final PageController controller; // Controlador del PageView

  SugestiveCardWidget({
    Key? key,
    required this.sugestiveList,
    required this.onTap,
    required this.currentIndex,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // altura de la tarjeta
      child: PageView.builder(
        padEnds: false,
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.start,
        itemCount: sugestiveList.length, // Longitud de la lista
        controller: controller, // Controlador del PageView
        onPageChanged: (int index) => onTap(index), // Evento de cambio de página
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: 1,
            child: GestureDetector(
              onTap: () => onTap(i), // Llama la función onTap con el índice actual
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Sombra suave
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      margin: EdgeInsets.zero,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: sugestiveList[i]["attributes"]["imagen"].toString(),
                          errorWidget: (context, url, error) => Text("Error"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70,
                            child: Text(
                              sugestiveList[i]["attributes"]["title"].toString(),
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'RobotoMono',
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.center,
                            child: BigText(
                              text: "S/ " + sugestiveList[i]["attributes"]["precion_base"].toString(),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
