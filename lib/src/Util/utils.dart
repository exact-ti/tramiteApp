import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/BottomNBPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'dart:convert';
import 'loader.dart';

EnvioController envioController = new EnvioController();
Menu menu = new Menu();
final _prefs = new PreferenciasUsuario();



String titulosPage(int pos) {
  switch (pos) {
    case 0:
      return "Fist BCP";
      break;
    case 1:
      return "Second BBVA";
    case 2:
      return "Pagina principal";
    default:
      return "Fist BCP";
  }
}

void eliminarpreferences(BuildContext context) async {
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  Provider.of<NotificationInfo>(context, listen: false).finalizarSubcripcion =
      1;
  sharedPreferences.clear();
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

Future<String> getDataFromCamera(BuildContext context) async {
  desenfocarInputfx(context);
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
  FocusScope.of(context).requestFocus(new FocusNode()); 
  new TextEditingController().clear();
}

void popuptoinput(BuildContext context, FocusNode fx, String tipo,
    String titulo, String mensaje) async {
  bool respuestatrue = await notificacion(context, tipo, titulo, mensaje);
  if (respuestatrue) {
    enfocarInputfx(context, fx);
  }
}

BoxDecoration myBoxDecoration(Color colorparam) {
  return BoxDecoration(
      border: Border.all(color: colorparam),
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
              color: StylesThemeData.LETTERCOLOR, fontSize: 20, fontWeight: FontWeight.bold)));
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
            style: TextStyle(fontSize: 20, color: StylesThemeData.LETTERCOLOR),
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
              maxHeight: !boolIfPerfil()
                  ? MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top
                  : MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      63),
          child: principal));
}

Widget scaffoldbodyLogin(Widget principal, BuildContext context) {
  return SingleChildScrollView(
      child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height),
          child: principal));
}

int obtenerCantidadMinima() {
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
  UtdModel utdModel = new UtdModel();
  if (_prefs.utd!=null) {
      Map<String, dynamic> utd = json.decode(_prefs.utd);
  UtdModel umodel = utdModel.fromPreferencs(utd);
    return umodel.id;

  }else{
    return 0;
  }
}

int obtenerBuzonid() {
  BuzonModel buzonModel = new BuzonModel();
  Map<String, dynamic> buzon = json.decode(_prefs.buzon);
  BuzonModel bmodel = buzonModel.fromPreferencs(buzon);
  return bmodel.id;
}

Widget drawerIfPerfil() {
  if (_prefs.tipoperfil == cliente) {
    return null;
  } else {
    return DrawerPage();
  }
}

bool boolIfPerfil() {
  if (_prefs.tipoperfil == cliente) {
    return true;
  } else {
    return false;
  }
}

void navegarHomeExact(BuildContext context) {
  Menu menu = new Menu();
  if (_prefs.menus != null) {
    List<dynamic> menus = json.decode(_prefs.menus);
    List<Menu> listmenu = menu.fromPreferencs(menus);
    for (Menu men in listmenu) {
      if (men.home) {
        if (_prefs.tipoperfil== cliente) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      new TopLevelWidget(rutaPage: men.link)));
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              men.link, (Route<dynamic> route) => false);
        }
      }
    }
  }
}


void navegarNotificaciones(BuildContext context) {
        if (_prefs.tipoperfil== cliente) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      new TopLevelWidget(rutaPage: "/notificaciones")));
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/notificaciones", (Route<dynamic> route) => false);
        }
}

String validateEmail(String value) {
  if (value == "") {
    return null;
  } else {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'El correo electrónico es inválido';
    else
      return null;
  }
}

String rutaPrincipal() {
  List<Menu> listmenu = menu.fromPreferencs(json.decode(_prefs.menus));
  return listmenu
      .where((element) => element.home)
      .map((e) => e.link)
      .toList().first;
}
