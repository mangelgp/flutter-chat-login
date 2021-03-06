import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_app/helpers/mostrar_alerta.dart';
import 'package:realtime_chat_app/services/auth_service.dart';
import 'package:realtime_chat_app/services/socket_service.dart';
import 'package:realtime_chat_app/widgets/btn_azul.dart';
import 'package:realtime_chat_app/widgets/custom_input.dart';
import 'package:realtime_chat_app/widgets/labels.dart';
import 'package:realtime_chat_app/widgets/logo.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Logo(title: 'Registro'),
                _Form(),
                Labels(ruta: 'login', isLogin: false,),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ]
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameController  = TextEditingController();
  final emailController = TextEditingController();
  final passController  = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        children: [

          CustomInput(
            controller: nameController,
            icon: Icons.perm_identity,
            hintText: 'Nombre',
            keyboardType: TextInputType.name,
          ),

          CustomInput(
            controller: emailController,
            icon: Icons.mail_outline,
            hintText: 'Correo',
            keyboardType: TextInputType.emailAddress,
          ),

          CustomInput(
            controller: passController,
            icon: Icons.lock_outline,
            hintText: 'Contraseña',
            isPassword: true,
          ),

          BtnAzul(
            text: 'Crear cuenta',
            press: authService.autenticando ?
            null : () async {
              FocusScope.of(context).unfocus(); // eliminar el foco actual, cerrar teclado si esta abierto
              print(emailController.text);
              print(passController.text);
              final resp = await authService.register(
                nombre: nameController.text.trim(), 
                email: emailController.text.trim(), 
                password: passController.text.trim()
              );
              if (resp) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                mostrarAlerta(
                  context: context,
                  titulo: 'Imposible registrar',
                  subtitulo: 'Porfavor verifique sus credenciales'
                );
              }
            },
          ) 
        ],
      ),
    );
  }
}
