import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Login/loginPage.dart';
import 'package:tramiteapp/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Componentes App',
      debugShowCheckedModeBanner: false,
      //home: HomePage()
      initialRoute: '/',  
      routes: getAplicationRoutes(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) =>LoginPage()
        );
      },

    );
  }
}