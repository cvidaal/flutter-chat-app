import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String subLabel;
  final String label;

  const Labels({super.key, required this.ruta, required this.subLabel, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            subLabel,
            // ¿Ya tienes cuenta?
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.pushReplacementNamed(context, ruta),
          )
        ],
      ),
    );
  }
}
