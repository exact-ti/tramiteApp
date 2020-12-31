import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class MenuController {
  final icons = <String, IconData>{
    'home': FontAwesomeIcons.home,
    'envio': FontAwesomeIcons.solidPaperPlane,
    'recorrido': FontAwesomeIcons.running,
    'importar': FontAwesomeIcons.fileUpload,
    'custodiar': FontAwesomeIcons.inbox,
    'clasificar': FontAwesomeIcons.stream,
    'interutd': FontAwesomeIcons.exchangeAlt,
    'revalija': FontAwesomeIcons.conciergeBell,
    'lote': FontAwesomeIcons.archive,
    'relote': FontAwesomeIcons.boxOpen,
    'agencia': FontAwesomeIcons.truck,
    'recepcion': Icons.receipt,
    'consulta': FontAwesomeIcons.peopleArrows,
    'enUTD': FontAwesomeIcons.building,
    'dashboard': FontAwesomeIcons.chartLine,
    'activos': FontAwesomeIcons.fileExport,
    'confirmar': FontAwesomeIcons.clipboardCheck,
    'historico': FontAwesomeIcons.history,
    'retiro': FontAwesomeIcons.solidMinusSquare,
    'HomeDashboard': FontAwesomeIcons.home
  };

  List<String> listRutasRecorridos = [
    "/recorridos",
    "/entregas-pisos-validacion",
    "/entregas-pisos-propios",
    "/entregas-pisos-adicionales",
    "/miruta",
    "/detalleruta",
    "/entrega-regular",
    "/entrega-personalizada",
    "/personalizada-dni",
    "/generar-firma",
    "/registrar-firma"
  ];

  List<String> listRutasUsuarios = ["/generar-envio", "/crear-envio","/envio-confirmado"];

  List<String> listRutasAgencias = ['/envios-agencia', '/nuevo-agencia'];

  List<String> listIntersedes = [
    '/envio-interutd',
    '/recepcionar-valija',
    '/nueva-entrega-intersede'
  ];

  List<String> listLotes = ['/envio-lote', '/nuevo-Lote', '/recepcionar-lote'];

  List<String> listPaquetes = ['/paquete-externo', '/importar-paquete'];

  modificarUtdOrBuzon(BuildContext context, int tipo) async {
    double heightCel = 0.6 * (MediaQuery.of(context).size.height);
    List<dynamic> opciones = new List();
    final _prefs = new PreferenciasUsuario();
    if (tipo == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
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
                        style: TextStyle(
                            color: StylesThemeData.LETTER_COLOR, fontSize: 12),
                      ),
                    )),
                onTap: () async {
                  bool respuestabool = await confirmacion(context, "success",
                      "EXACT", "¿Seguro que desea continua?");
                  if (respuestabool) {
                    if (tipo == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
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
            title: Text(tipo == TipoPerfilEnum.TIPO_PERFIL_CLIENTE
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
