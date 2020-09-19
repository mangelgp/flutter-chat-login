import 'package:flutter/material.dart';

mostrarAlerta({@required BuildContext context, @required String titulo, @required String subtitulo}) {

  showDialog(
    context: context,
    builder: ( _ ) => AlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        MaterialButton(
          child: Text('Aceptar'),
          textColor: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ],
    )
  );

}