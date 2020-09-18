import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';

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
    cargarPreferences();
  }

  @override
  Widget build(BuildContext context) {
    const LetraColor = const Color(0xFF68A1C8);
 
    return Scaffold(
      appBar: CustomAppBar(text: "Bienvenido"),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 300.0),
            Center(
                child: Text("EXACT",
                    style: TextStyle(
                        fontSize: 30,
                        color: LetraColor,
                        fontWeight: FontWeight.bold))),
            Center(
                child: Text("Expertos en Gestion Documental",
                    style: TextStyle(fontSize: 20, color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  void cargarPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
