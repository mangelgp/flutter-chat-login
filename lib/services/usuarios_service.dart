import 'package:http/http.dart' as http;
import 'package:realtime_chat_app/global/environment.dart';

import 'package:realtime_chat_app/models/usuario.dart';
import 'package:realtime_chat_app/models/usuarios_response.dart';
import 'package:realtime_chat_app/services/auth_service.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    try {
      
      final resp = await http.get('${Environment.apiUrl}/usuarios', 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;

    } catch (e) {
      print(e.toString());      
    }

  }

}