import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationController;

  ChatMessage({
    Key key, 
    @required this.texto, 
    @required this.uid, 
    @required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == '123'
          ? _myMessage(context)
          : _notMyMessage(context),    
        ),
      ),
    );
  }

  Widget _myMessage(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 5.0, left: MediaQuery.of(context).size.width * 0.15, right: 5.0),
        padding: EdgeInsets.all(10.0),
        child: Text(this.texto, style: TextStyle(color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xFF4D9EF6),
          borderRadius: BorderRadius.circular(17.0)
        ),
      ),
    );
  }

  Widget _notMyMessage(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 5.0, right: MediaQuery.of(context).size.width * 0.15, left: 5.0),
        padding: EdgeInsets.all(10.0),
        child: Text(this.texto, style: TextStyle(color: Colors.black87),),
        decoration: BoxDecoration(
          color: Color(0xFFE4E5E8),
          borderRadius: BorderRadius.circular(17.0)
        ),
      ),
    );
  }
}