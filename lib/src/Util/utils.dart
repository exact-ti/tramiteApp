import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Drawer crearMenu(BuildContext context) {
  return Drawer(
    child: ListView(padding: EdgeInsets.zero, 
    children: milistview(context)),
  );
}

List<Widget> milistview(BuildContext context) {
  List<Widget> list = new List<Widget>();
  final _prefs = new PreferenciasUsuario();
  Menu menuu = new Menu();
  List<dynamic> menus = json.decode(_prefs.menus);
  List<Menu> listmenu = menuu.fromPreferencs(menus);
  list.add(DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/original.jpg'),
                      fit: BoxFit.cover)),
            ));
  for (Menu men in listmenu) {
    list.add(ListTile(
        leading: Icon(Icons.pages, color: Colors.blue),
        title: Text(men.nombre),
        onTap: () => Navigator.pushReplacementNamed(context, men.link)));
  }
  return list;
}
