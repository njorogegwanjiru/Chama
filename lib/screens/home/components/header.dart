import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '👑',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          'Qu',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
        ),
        Text(
          'ee',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        Text(
          'nS',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
        ),
        Text(
          '👑',
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }
}
