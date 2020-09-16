import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String title;

  const Logo({
    Key key, 
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/img/tag-logo.png'),
            width: size.width * 0.4,
          ),
          SizedBox(height: 15.0,),
          Text(this.title, style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}