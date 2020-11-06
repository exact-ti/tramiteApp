import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class MenuController {

  final icons = <String, IconData>{
    'home': Icons.home,
    'envio': Icons.send,
    'recorrido': Icons.directions_run,
    'importar': Icons.file_upload,
    'custodiar': Icons.check_box,
    'clasificar': Icons.sort,
    'interutd': Icons.transfer_within_a_station,
    'revalija': Icons.markunread,
    'lote': Icons.check_box_outline_blank,
    'relote': Icons.filter_none,
    'agencia': Icons.airline_seat_recline_normal,
    'recepcion': Icons.receipt,
    'consulta': Icons.record_voice_over,
    'dashboard': Icons.dashboard,
    'activos': Icons.accessibility,
    'confirmar': Icons.confirmation_number,
    'historico': Icons.history,
    'retiro': Icons.remove_circle_outline
  };


    modificarUtdOrBuzon(BuildContext context, int tipo) async {
    double heightCel = 0.6 * (MediaQuery.of(context).size.height);
    List<dynamic> opciones = new List();
    final _prefs = new PreferenciasUsuario();
    if (tipo == cliente) {
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
      listadecodigos.add(Container(
          decoration: myBoxDecoration(StylesThemeData.LETTER_COLOR),
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              InkWell(
                child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        opcion.nombre,
                        style: TextStyle(color: StylesThemeData.LETTER_COLOR, fontSize: 12),
                      ),
                    )),
                onTap: () async {
                  bool respuestabool = await confirmacion(context, "success",
                      "EXACT", "¿Seguro que desea continua?");
                    if (respuestabool) {
                      if (tipo == cliente) {
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
                      Navigator.of(context).pushNamed('/principal-admin');
                    }
                },
              )
            ],
          )));
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(tipo == cliente
                ? "Seleccione un nuevo buzón"
                : "Seleccione un nuevo UTD"),
            content: Container(
                height: heightCel,
                width: MediaQuery.of(context).size.width,
                child: Column(children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: listadecodigos)))
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }


}
