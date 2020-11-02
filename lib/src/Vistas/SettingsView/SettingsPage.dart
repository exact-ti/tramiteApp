import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Gestion-password/CambiarPassworPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
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
    Widget mainscaffold() {
      return SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: nombreCuenta,
                subtitle: boolIfPerfil() ? 'Cambiar usuario' : 'Cambiar UTD',
                leading: Icon(FontAwesomeIcons.userEdit),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CountChangePage(),
                    ),
                  ).whenComplete(cambiarBuzonOrUtd);
                },
              ),
              SettingsTile(
                title: 'Contraseña',
                subtitle: 'Cambiar contraseña',
                leading: Icon(FontAwesomeIcons.lock),
                trailing: Icon(Icons.keyboard_arrow_right),
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
              SettingsTile(
                title: 'Cerrar sesión',
                leading: Icon(FontAwesomeIcons.doorOpen),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  bool respuestaPop = await confirmacion(context, "success",
                      "EXACT", "¿Seguro que desea cerrar sesión?");
                  if (respuestaPop) {
                    eliminarpreferences(context);
                  }
                },
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARYCOLOR,
            title: Text("Cuenta",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
