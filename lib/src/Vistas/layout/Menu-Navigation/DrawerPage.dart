import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/MenuController.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

// ignore: must_be_immutable
class DrawerPage extends StatelessWidget {
  MenuController menuController = new MenuController();
  final _prefs = new PreferenciasUsuario();

  Icon getICon(String nombreIcono) {
    return Icon(menuController.icons[nombreIcono], color: Colors.blue);
  }

  Widget menuOpcion(BuildContext context) {
    if (_prefs.tipoperfil == cliente) {
      dynamic buzon = json.decode(_prefs.buzon);
      return ListTile(
          leading: Icon(Icons.assignment_ind, color: Colors.blue),
          title: Text(buzon["nombre"]),
          onTap: () {
            menuController.modificarUtdOrBuzon(context, cliente);
          });
    } else {
      dynamic utd = json.decode(_prefs.utd);
      return ListTile(
          leading: Icon(Icons.business, color: Colors.blue),
          title: Text(utd["nombre"]),
          onTap: () {
            menuController.modificarUtdOrBuzon(context, exact);
          });
    }
  }

  Widget cerrarsesion(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.exit_to_app, color: Colors.blue),
        title: Text("Cerrar Sesión"),
        onTap: () {
          eliminarpreferences(context);
        });
  }

  List<Widget> milistview(BuildContext context) {
    List<Widget> list = new List<Widget>();
    final _prefs = new PreferenciasUsuario();
    if (_prefs.token != "") {
      Menu menuu = new Menu();
      List<dynamic> menus = json.decode(_prefs.menus);
      List<Menu> listmenu = menuu.fromPreferencs(menus);
      listmenu.sort((a, b) => a.orden.compareTo(b.orden));
      listmenu.reversed;
      list.add(DrawerHeader(
        child: Container(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/imagen-menu.jpg'), fit: BoxFit.cover)),
      ));
      for (Menu men in listmenu) {
        list.add(ListTile(
            leading: getICon(men.icono),
            title: Text(men.nombre),
            onTap: () => Navigator.of(context).pushNamed(men.link)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return  Drawer(
            child: ListView(
                padding: EdgeInsets.zero, children: milistview(context)),
          );
  }
}
