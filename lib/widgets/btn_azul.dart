import 'package:flutter/material.dart';

class BtnAzul extends StatelessWidget {

  final Function press;
  final String text;

  const BtnAzul({
    Key key, 
    @required this.press, 
    @required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: this.press,
      child: Container(
        width: double.infinity,
        height: 55.0,
        child: Center(
          child: Text(this.text, style: TextStyle( color: Colors.white, fontSize: 17.0 ))
        )
      ),
    );
  }
}