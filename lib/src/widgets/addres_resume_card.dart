import 'package:flutter/material.dart';
import 'package:villachicken/src/widgets/big_text.dart';

// Define un widget reutilizable
class AddressResumeWidget extends StatelessWidget {
  final String title;
  final String? addressName;
  final String? addressDetails;
  final String? phoneNumber;
  final Color iconColor;

  // Constructor que recibe los parámetros necesarios
  const AddressResumeWidget({
    Key? key,
    required this.title,
    this.addressName,
    this.addressDetails,
    this.phoneNumber,
    this.iconColor = Colors.blue, // Color por defecto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Icon(Icons.home, color: iconColor), // Icono con color configurable
            const SizedBox(width: 10), // Espacio entre icono y texto
            BigText(text: title, size: 12), // Texto personalizado para el título
          ],
        ),
        const SizedBox(height: 5), // Espacio entre filas
        Text(
          addressName ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.black87), // Estilo del texto principal
        ),
        const SizedBox(height: 3),
        Text(
          addressDetails ?? '',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600, // Color gris suave para texto adicional
          ),
        ),
        const SizedBox(height: 8), // Espacio entre filas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigText(
              text: 'Contacto: ${phoneNumber}' ?? '',
              size: 14,
              color: Colors.black, // Color resaltado para el número de teléfono
            ),
          ],
        ),
      ],
    );
  }
}