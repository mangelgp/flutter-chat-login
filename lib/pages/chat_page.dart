import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_app/models/mensajes_response.dart';
import 'package:realtime_chat_app/models/usuario.dart';
import 'package:realtime_chat_app/services/auth_service.dart';
import 'package:realtime_chat_app/services/chat_service.dart';
import 'package:realtime_chat_app/services/socket_service.dart';
import 'package:realtime_chat_app/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _chatController = TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.chatService = Provider.of<ChatService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioId) async {

    List<Mensaje> chat = await this.chatService.getchat(usuarioId);
    // print(chat);
    final historial = chat.map((mensaje) => ChatMessage(
      texto: mensaje.mensaje, 
      uid: mensaje.de, 
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds:  0))..forward()
    ));

    setState(() {
      _messages.insertAll(0, historial);
    });

  }

  void _escucharMensaje(dynamic data) {

    print('tengo mensaje $data');
    ChatMessage message = ChatMessage(
      texto: data['mensaje'], 
      uid: data['de'], 
      animationController: AnimationController( vsync: this, duration:  Duration(milliseconds: 300) )
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  void dispose() {
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    _chatController.dispose();
    _focusNode.dispose();
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: _buildAppBar(usuarioPara),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => _messages[index],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(),
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            )
          ],
        )
      )
    );
  }

  AppBar _buildAppBar(Usuario usuarioPara) {
    return AppBar(
      elevation: 1.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            maxRadius: 14.0,
            child: Text( usuarioPara.nombre.substring(0,2) ),
            backgroundColor: Colors.blue[100],
          ),
          SizedBox(height: 5.0,),
          Text(usuarioPara.nombre, style: TextStyle(color: Colors.black54, fontSize: 12))
        ],
      )
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _chatController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    if(texto.trim().length > 0) {
                      _isWritting = true;
                    } else {
                      _isWritting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              // margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: IconTheme(
                data: IconThemeData(color: Colors.blue[400]),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.send), 
                  onPressed: _isWritting ?
                    () => _handleSubmit(_chatController.text.trim()) : null
                ),
              )
            )
          ],
        )
      ),
    );
  }

  _handleSubmit(String text) {

    if(text.length == 0) return;

    // print(text);
    _chatController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: authService.usuario.uid, 
      texto: text,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWritting = false;
    });

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': text
    });
  }
}