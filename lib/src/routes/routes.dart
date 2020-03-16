import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Login/loginPage.dart';
import 'package:tramiteapp/src/principal/principalPage.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    'principal-admin': (BuildContext context) => PrincipalPage(),
  };
}
