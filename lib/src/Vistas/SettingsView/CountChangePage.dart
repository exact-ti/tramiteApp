import 'dart:collection';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Util/modals/confirmation.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'SettingsController.dart';

class CountChangePage extends StatefulWidget {
  @override
  _CountChangePageState createState() => _CountChangePageState();
}

class _CountChangePageState extends State<CountChangePage> {
  SettingsController settingscontroller = new SettingsController();
  final _prefs = new PreferenciasUsuario();
  String nombreCuenta = "";
  List<dynamic> listarOpciones = new List();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListado() {
      List<dynamic> opciones = new List();
      if (tipoPerfil(_prefs.perfil) == cliente) {
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
              bool respuestabool = await confirmacion(
                  context, "success", "EXACT", "¿Seguro que desea continuar?");
              if (respuestabool) {
                if (tipoPerfil(_prefs.perfil) == cliente) {
                  HashMap<String, dynamic> buzonhash = new HashMap();
                  buzonhash['id'] = opcion.id;
                  buzonhash['nombre'] = opcion.nombre;
                  _prefs.buzon = buzonhash;
                } else {
                  HashMap<String, dynamic> utdhash = new HashMap();
                  utdhash['id'] = opcion.id;
                  utdhash['nombre'] = opcion.nombre;
                  _prefs.utd = utdhash;
                }
                Navigator.of(context).pop();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
                  ),
                ),
                child: ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(opcion.nombre,
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  leading: boolIfPerfil()
                      ? Icon(FontAwesomeIcons.userAlt)
                      : Icon(FontAwesomeIcons.home),
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
                color: Colors.grey[200],
                alignment: Alignment.bottomCenter,
                child: _crearListado()),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
                tipoPerfil(_prefs.perfil) == cliente
                    ? "Cambiar buzón"
                    : "Cambiar UTD",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
