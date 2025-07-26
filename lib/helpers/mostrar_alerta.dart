import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(titulo),
          content: Text(subtitulo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok', style: TextStyle(color: Colors.blue)),
            )
          ],
        );
      },
    );
  }
}
