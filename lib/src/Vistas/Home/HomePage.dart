import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';

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
                FlatButton(
                  child: Text("Log Out", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    sharedPreferences.clear();
                    sharedPreferences.commit();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            ),
          ),
        );
      }
    
      void cargarPreferences() async {
              sharedPreferences = await SharedPreferences.getInstance();

      }
}
