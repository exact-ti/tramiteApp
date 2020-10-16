import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String title;

  const SecondPage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args ?? "Page Transition Plugin"),
      ),
      body: Center(
        child: Text('Second Page'),
      ),
    );
  }
}

