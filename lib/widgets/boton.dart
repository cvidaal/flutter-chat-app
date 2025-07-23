// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class boton extends StatelessWidget {
  final String text;
  void Function() onPressed;

  boton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.blue,
          shape: StadiumBorder(),
          backgroundColor: Colors.blue,
          padding: EdgeInsets.zero,
        ),
        child: Container(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
