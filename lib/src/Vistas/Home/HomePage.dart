import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/layout/top-bar/topBarPage.dart';

class HomePage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
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
      drawer: sd.crearMenu(context),
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
