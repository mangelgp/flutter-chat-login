import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final bool isLogin;

  const Labels({
    Key key, 
    @required this.ruta, 
    this.isLogin = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Text(isLogin ? '¿No tienes cuenta?' : "¿Ya tienes cuenta?", style: 
            TextStyle(color: Colors.black54, fontSize: 15.0, fontWeight: FontWeight.w300)
          ),
          SizedBox(height: 10.0,),
          GestureDetector(
            child: Text( this.isLogin ? 'Crea una  ahora!' : 'Inicia sesión', style: 
              TextStyle(color: Colors.blue[600], fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              print('tap');
              Navigator.pushReplacementNamed(context, this.ruta);
            },
          ),
        ],
      ),
    );
  }
}