import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat_app/global/environment.dart';
import 'package:realtime_chat_app/models/mensajes_response.dart';

import 'package:realtime_chat_app/models/usuario.dart';
import 'package:realtime_chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {

  Usuario usuarioPara;

  Future<List<Mensaje>> getchat(String usuarioId) async {

    final resp = await http.get('${Environment.apiUrl}/mensajes/$usuarioId',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    if (resp.statusCode == 200) {
      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
    } else {
      return null;
    }

  }

}