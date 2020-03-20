import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';


Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    '/principal-admin': (BuildContext context) => HomePage(),
  };
}
