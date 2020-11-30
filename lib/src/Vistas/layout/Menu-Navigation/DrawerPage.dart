import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/MenuController.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

// ignore: must_be_immutable
class DrawerPage extends StatelessWidget {
  MenuController menuController = new MenuController();

  Icon getICon(String nombreIcono, Color colorIcon) {
    return Icon(menuController.icons[nombreIcono], color: colorIcon);
  }

  List<Widget> milistview(BuildContext context) {
    List<Widget> list = new List<Widget>();
    final _prefs = new PreferenciasUsuario();
    if (_prefs.token != "") {
      Menu menuu = new Menu();
      List<dynamic> menus = _prefs.menus==null?[]: json.decode(_prefs.menus);
      List<Menu> listmenu = menuu.fromPreferencs(menus);
      listmenu.sort((a, b) => a.orden.compareTo(b.orden));
      listmenu.reversed;
      final String nombreUsuario =
          Provider.of<NotificationInfo>(context).nombreUsuario;
      list.add(DrawerHeader(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                color: StylesThemeData.PRIMARY_COLOR,
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                        child: Text(
                      nombreUsuario[0],
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    )),
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Text(
                "$nombreUsuario",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/header.png'),
                fit: BoxFit.cover)),
      ));
      for (Menu men in listmenu) {
        Color colorBackground = Colors.white;
        Color colorLetter = StylesThemeData.LETTER_COLOR;
        Color colorIcon = StylesThemeData.ICON_COLOR;

        var route = ModalRoute.of(context);

        if (route != null && route.settings.name.toString() == men.link) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listRutasRecorridos
                .contains(route.settings.name.toString()) &&
            menuController.listRutasRecorridos.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listRutasUsuarios
                .contains(route.settings.name.toString()) &&
            menuController.listRutasUsuarios.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listRutasAgencias
                .contains(route.settings.name.toString()) &&
            menuController.listRutasAgencias.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listIntersedes
                .contains(route.settings.name.toString()) &&
            menuController.listIntersedes.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listLotes.contains(route.settings.name.toString()) &&
            menuController.listLotes.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        if (route != null &&
            menuController.listPaquetes
                .contains(route.settings.name.toString()) &&
            menuController.listPaquetes.contains(men.link)) {
          colorBackground = StylesThemeData.PRIMARY_COLOR;
          colorLetter = Colors.white;
          colorIcon = Colors.white;
        }

        list.add(Container(
            decoration: new BoxDecoration(color: colorBackground),
            child: ListTile(
                leading: getICon(men.icono, colorIcon),
                title: Text(
                  men.nombre,
                  style: TextStyle(color: colorLetter),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(men.link);
                })));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: milistview(context)),
    );
  }
}
