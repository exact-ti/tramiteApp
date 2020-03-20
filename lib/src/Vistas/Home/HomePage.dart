import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;


class HomePage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8);
    const Colorplomo = const Color(0xFFEAEFF2);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: 
        Text('Bienvenido', style: TextStyle(
            fontSize: 18,
            decorationStyle: TextDecorationStyle.wavy,
            fontStyle:FontStyle.normal,
            fontWeight: FontWeight.normal
        )),
      ),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 300.0),
            Center(child:Text("EXACT",style: TextStyle(fontSize: 30,color: LetraColor,fontWeight: FontWeight.bold))),
            Center(child:Text("Expertos en Gestion Documental",style: TextStyle(fontSize: 20,color:Colors.grey)))
          ],
        ),
      ),
    );
  }
}
//                  Navigator.of(context).pushNamed(men.link);
