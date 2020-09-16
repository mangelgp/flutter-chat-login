import 'package:flutter/material.dart';

import 'package:realtime_chat_app/pages/chat_page.dart';
import 'package:realtime_chat_app/pages/loading_page.dart';
import 'package:realtime_chat_app/pages/login_page.dart';
import 'package:realtime_chat_app/pages/register_page.dart';
import 'package:realtime_chat_app/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users'   : (_) => UsuariosPage(),
  'chat'    : (_) => ChatPage(),
  'login'   : (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading' : (_) => LoadingPage(),
};