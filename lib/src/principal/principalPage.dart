import 'package:flutter/material.dart';


class PrincipalPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('BIENVENIDO AL SISTEMA'),
      ),
      body: Center(
        child: Text('BIENVENIDO'),
      ),
    );
  }

}