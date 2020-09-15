import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';
import 'loader.dart';
import 'modals/information.dart';

EnvioController envioController = new EnvioController();

final primaryColor = Color(0xFF2C6983);
final colorletra = Color(0xFFACADAD);
final colorplomo = Color(0xFFEAEFF2);
final colorblanco = Color(0xFFFFFFFF);

int tipoPerfil(String perfilId) {
  switch (perfilId) {
    case "1":
      return exact;
      break;
    case "2":
      return exact;
    case "3":
      return exact;
      break;
    case "4":
      return cliente;
    default:
      return exact;
  }
}

String titulosPage(String pos) {
  switch (pos) {
    case "first":
      return "Fist BCP";
      break;
    case "second":
      return "Second BBVA";
    case "home":
      return "Pagina principal";
    default:
      return "Fist BCP";
  }
}

void eliminarpreferences(BuildContext context) async {
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  sharedPreferences.commit();
  if (context != null) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}

void deletepreferencesWithoutContext() async {
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  sharedPreferences.commit();
}

void redirection(BuildContext context, String ruta) {
  Navigator.pushReplacementNamed(context, ruta);
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context,
    {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).height - reducedBy) / dividedBy;
}

double screenHeightExcludingToolbar(BuildContext context,
    {double dividedBy = 1}) {
  return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
}

Future<String> getDataFromCamera() async {
  var scanResult = await BarcodeScanner.scan();
  String qrbarra = scanResult;
  return qrbarra;
}

void enfocarInputfx(BuildContext context, FocusNode fx) {
  FocusScope.of(context).unfocus();
  new TextEditingController().clear();
  FocusScope.of(context).requestFocus(fx);
}

void desenfocarInputfx(BuildContext context) {
  FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
  new TextEditingController().clear();
}

void popuptoinput(BuildContext context, FocusNode fx, String tipo,
    String titulo, String mensaje) async {
  bool respuestatrue = await notificacion(context, tipo, titulo, mensaje);
  if (respuestatrue) {
    enfocarInputfx(context, fx);
  }
}

BoxDecoration myBoxDecoration(Color colorletra) {
  return BoxDecoration(
      border: Border.all(color: colorletra),
      borderRadius: BorderRadius.circular(5));
}

BoxDecoration myBigBoxDecoration(Color colorletra) {
  return BoxDecoration(
    border: Border.all(color: colorletra),
  );
}

Widget sinResultados(String mensaje) {
  return Center(
      child: Text(mensaje,
          style: TextStyle(
              color: colorletra, fontSize: 20, fontWeight: FontWeight.bold)));
}

Widget loadingGet() {
  return new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        child: ColorLoader3(
          radius: 40.0,
          dotRadius: 10.0,
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 5),
          child: FadingText(
            "Loading",
            style: TextStyle(fontSize: 20, color: colorletra),
          )),
    ],
  );
}

Widget textHipervinculo(String text) {
  return Text(text,
      style: TextStyle(
          decoration: TextDecoration.underline, color: Colors.blue[300]));
}

Widget scaffoldbody(Widget principal, BuildContext context) {
  return SingleChildScrollView(
      child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top),
          child: principal));
}

int obtenerCantidadMinima() {
  final _prefs = new PreferenciasUsuario();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();
  List<dynamic> configuraciones = json.decode(_prefs.configuraciones);
  List<ConfiguracionModel> configuration =
      configuracionModel.fromPreferencs(configuraciones);
  int cantidad = 0;
  for (ConfiguracionModel confi in configuration) {
    if (confi.nombre == "CARACTERES_MINIMOS_BUSQUEDA") {
      cantidad = int.parse(confi.valor);
    }
  }
  return cantidad;
}

int obtenerUTDid() {
  final _prefs = new PreferenciasUsuario();
  UtdModel utdModel = new UtdModel();
  Map<String, dynamic> utd = json.decode(_prefs.utd);
  UtdModel umodel = utdModel.fromPreferencs(utd);
  int id = umodel.id;
  return id;
}

int obtenerBuzonid() {
  final _prefs = new PreferenciasUsuario();
  BuzonModel buzonModel = new BuzonModel();
  Map<String, dynamic> buzon = json.decode(_prefs.buzon);
  BuzonModel umodel = buzonModel.fromPreferencs(buzon);
  int id = umodel.id;
  return id;
}
