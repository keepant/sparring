import 'package:flutter/material.dart';
import 'package:sparring/i18n.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).title),
      ),
      body: Center(
        child: Text(
          I18n.of(context).hello,
        ),
      ),
    );
  }
}
