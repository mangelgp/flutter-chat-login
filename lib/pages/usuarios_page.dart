import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat_app/models/usuario.dart';
import 'package:realtime_chat_app/services/auth_service.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(
      email: 'test1@test.com',
      nombre: 'Maria',
      online: false,
      uid: '1'
    ),
    Usuario(
      email: 'test2@test.com',
      nombre: 'Juan',
      online: true,
      uid: '2'
    ),Usuario(
      email: 'test3@test.com',
      nombre: 'Jared',
      online: true,
      uid: '3'
    )
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario.nombre, style: TextStyle(color: Colors.black87) ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87), 
          onPressed: () async {
            // TODO: desconectarse del socket server
            await authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            // child: Icon(Icons.offline_bolt, color: Colors.red)
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        enablePullDown: true,
      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      itemBuilder: (context, index) => _userListTile(usuarios[index]), 
      separatorBuilder: (context, index) => Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _userListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[200],
          child: Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(10.0)
          ),
        ),
      );
  }

  void _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}