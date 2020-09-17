import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat_app/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _chatController = TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  void dispose() {
    //TODO: Off del socket
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    _chatController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            maxRadius: 14.0,
            child: Text('Te'),
            backgroundColor: Colors.blue[100],
          ),
          SizedBox(height: 5.0,),
          Text('Melissa Flores', style: TextStyle(color: Colors.black54, fontSize: 12))
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

    print(text);
    _chatController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123', 
      texto: text,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWritting = false;
    });
  }
}