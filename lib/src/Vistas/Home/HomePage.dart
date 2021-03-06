import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class HomePage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  NotificacionController notificacionController = new NotificacionController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Bienvenido"),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text("EXACT",
                  style: TextStyle(
                      fontSize: 30,
                      color: StylesThemeData.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold))),
          Center(
              child: Text("Expertos en Gestion Documental",
                  style: TextStyle(fontSize: 20, color: Colors.grey))),
        ],
      ),
    );
  }
}
