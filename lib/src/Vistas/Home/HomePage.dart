import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Util/modals/confirmation.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Util/utils.dart';

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
    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8);

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 70),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          confirmacion(context,"error ","EXACT","probando diseño de esta notificación probando diseño de esta");
        },
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        color: Colors.lightBlueAccent,
        child: Text('LOG IN', style: TextStyle(color: Colors.white)),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Bienvenido',
            style: TextStyle(
                fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal)),
      ),
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
            loginButton
          ],
        ),
      ),
    );
  }

  void cargarPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
