import 'dart:collection';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Icon_style.dart';
import 'SettingsController.dart';

class CountChangePage extends StatefulWidget {
  @override
  _CountChangePageState createState() => _CountChangePageState();
}

class _CountChangePageState extends State<CountChangePage> {
  SettingsController settingscontroller = new SettingsController();
  final _prefs = new PreferenciasUsuario();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void notifierAccion(String mensaje, Color colorNotifier) {
    final snack = new SnackBar(
      content: new Text(mensaje),
      backgroundColor: colorNotifier,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListado() {
      List<dynamic> opciones = new List();
      if (_prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
        BuzonModel buzonmodel = new BuzonModel();
        List<dynamic> buzonCore = json.decode(_prefs.buzones);
        opciones = buzonmodel.listfromPreferencs(buzonCore);
      } else {
        UtdModel utdModel = new UtdModel();
        List<dynamic> utdCore = json.decode(_prefs.utds);
        opciones = utdModel.listfromPreferencs(utdCore);
      }
      List<Widget> listadecodigos = new List();
      for (dynamic opcion in opciones) {
        listadecodigos.add(InkWell(
            onTap: () async {
              bool buzonUTDActual = false;
              if (_prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
                if (opcion.id == obtenerBuzonid()) {
                  buzonUTDActual = true;
                  notifierAccion("${opcion.nombre} es el buzón actual",
                      StylesThemeData.PRIMARY_COLOR);
                }
              } else {
                if (opcion.id == obtenerUTDid()) {
                  buzonUTDActual = true;
                  notifierAccion("${opcion.nombre} es la UTD actual",
                      StylesThemeData.PRIMARY_COLOR);
                }
              }
              if (!buzonUTDActual) {
                bool respuestabool = await confirmacion(context, "success",
                    "EXACT", "¿Seguro que desea continuar?");
                if (respuestabool) {
                  if (_prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
                    if (opcion.id == obtenerBuzonid()) {
                      notifierAccion("${opcion.nombre} es el buzón actual",
                          StylesThemeData.PRIMARY_COLOR);
                    } else {
                      HashMap<String, dynamic> buzonhash = new HashMap();
                      buzonhash['id'] = opcion.id;
                      buzonhash['nombre'] = opcion.nombre;
                      _prefs.buzon = buzonhash;
                      bool respuesta = await notificacion(
                          context,
                          "success",
                          "EXACT",
                          "Se modificó el buzón, su buzón actual es ${opcion.nombre}");
                      if (respuesta) {
                        Provider.of<NotificationInfo>(context, listen: false)
                            .nombreUsuario = buzonhash['nombre'];
                        settingscontroller.gestionNotificaciones(context);
                        Navigator.of(context).pop();
                      }
                    }
                  } else {
                    if (opcion.id == obtenerUTDid()) {
                      notifierAccion("${opcion.nombre} es la UTD actual",
                          StylesThemeData.PRIMARY_COLOR);
                    } else {
                      HashMap<String, dynamic> utdhash = new HashMap();
                      utdhash['id'] = opcion.id;
                      utdhash['nombre'] = opcion.nombre;
                      _prefs.utd = utdhash;
                      bool respuesta = await notificacion(
                          context,
                          "success",
                          "EXACT",
                          "Se modificó la UTD, su UTD actual es ${opcion.nombre}");
                      if (respuesta) {
                        Provider.of<NotificationInfo>(context, listen: false)
                            .nombreUsuario = utdhash['nombre'];
                        Navigator.of(context).pop();
                      }
                    }
                  }
                }
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
                  ),
                ),
                child: ListTile(
                  trailing: Icon(IconsData.ICON_SEND_ARROW,
                      size: StylesIconData.ICON_SIZE,
                      color: _prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE
                          ? opcion.id == obtenerBuzonid()
                              ? Colors.blue
                              : StylesThemeData.ICON_COLOR
                          : opcion.id == obtenerUTDid()
                              ? Colors.blue
                              : StylesThemeData.ICON_COLOR),
                  title: Text(opcion.nombre,
                      style: TextStyle(
                          fontSize: 18,
                          color: _prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE
                              ? opcion.id == obtenerBuzonid()
                                  ? Colors.blue
                                  : Colors.black
                              : opcion.id == obtenerUTDid()
                                  ? Colors.blue
                                  : Colors.black)),
                  leading: boolIfPerfil()
                      ? Icon(IconsData.ICON_USER,
                          size: StylesIconData.ICON_SIZE,
                          color: opcion.id == obtenerBuzonid()
                              ? Colors.blue
                              : StylesThemeData.ICON_COLOR)
                      : Icon(IconsData.ICON_SEDE,
                          size: StylesIconData.ICON_SIZE,
                          color: opcion.id == obtenerUTDid()
                              ? Colors.blue
                              : StylesThemeData.ICON_COLOR),
                ))));
      }
      return Column(children: listadecodigos);
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                color: Colors.grey.shade200,
                alignment: Alignment.bottomCenter,
                child: _crearListado()),
          )
        ],
      );
    }

    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARY_COLOR,
            title: Text(
                _prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE ? "Cambiar buzón" : "Cambiar UTD",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
