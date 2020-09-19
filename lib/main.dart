import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat_app/services/auth_service.dart';
import 'package:realtime_chat_app/services/chat_service.dart';
import 'package:realtime_chat_app/services/socket_service.dart';
 
import 'package:realtime_chat_app/routes.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}