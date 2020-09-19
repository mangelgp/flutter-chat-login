import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_app/pages/login_page.dart';
import 'package:realtime_chat_app/pages/usuarios_page.dart';
import 'package:realtime_chat_app/services/auth_service.dart';
import 'package:realtime_chat_app/services/socket_service.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Iniciando Aplicación...'),
              SizedBox(height: 30.0,),
              Center(
                child: CircularProgressIndicator()
              ),
            ],
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: ( _, __, ___ ) => UsuariosPage(),
        transitionDuration: Duration(milliseconds: 100)
      ));
    } else {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: ( _, __, ___ ) => LoginPage(),
        transitionDuration: Duration(milliseconds: 100)
      ));
    }

  }
}