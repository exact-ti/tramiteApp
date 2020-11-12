import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Gestion-password/CambiarPassworPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Icon_style.dart';
import 'CountChangePage.dart';
import 'SettingsController.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingsController settingscontroller = new SettingsController();
  final _prefs = new PreferenciasUsuario();
  String nombreCuenta = "";
  @override
  void initState() {
    cambiarBuzonOrUtd();
    super.initState();
  }

  void cambiarBuzonOrUtd() {
    dynamic typePerfil = _prefs.tipoperfil == cliente
        ? json.decode(_prefs.buzon)
        : json.decode(_prefs.utd);
    if (this.mounted) {
      setState(() {
        nombreCuenta = typePerfil["nombre"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Container _buildDivider() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        width: double.infinity,
        height: 1.0,
        color: Colors.grey.shade400,
      );
    }


    Widget mainscaffold() {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: StylesThemeData.PRIMARY_COLOR,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CountChangePage(),
                    ),
                  ).whenComplete(cambiarBuzonOrUtd);
                },
                title: Text(
                  nombreCuenta,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: CircleAvatar(
                  child: Text(nombreCuenta[0]),
                ),
                trailing: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    IconsData.ICON_PADLOCK,
                    size: StylesIconData.ICON_SIZE,
                    color: StylesThemeData.ICON_COLOR,
                  ),
                  title: Text('Cambiar contraseña'),
                  trailing: Icon(IconsData.ICON_ITEM_WIDGETRIGHT,
                      size: StylesIconData.ICON_SIZE,
                      color: StylesThemeData.ICON_COLOR),
                  onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CambiarPasswordPage(),
                    ),
                  );
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(
                    IconsData.ICON_EXIT,
                    size: StylesIconData.ICON_SIZE,
                    color: StylesThemeData.ICON_COLOR,
                  ),
                  title: Text("Cerrar sesión"),
                  trailing: Icon(IconsData.ICON_ITEM_WIDGETRIGHT,
                      size: StylesIconData.ICON_SIZE,
                      color: StylesThemeData.ICON_COLOR),
                  onTap: () async{
                  bool respuestaPop = await confirmacion(context, "success",
                      "EXACT", "¿Seguro que desea cerrar sesión?");
                  if (respuestaPop) {
                    eliminarpreferences(context);
                  }
                  },
                ),
              ],
            ),
          ),
        ],
      ));
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARY_COLOR,
            title: Text("Cuenta",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        backgroundColor: Colors.grey.shade200,
        body: scaffoldbody(mainscaffold(), context));
  }
}
