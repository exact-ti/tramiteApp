import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import 'modals/confirmation.dart';

EnvioController envioController = new EnvioController();

Drawer crearMenu(BuildContext context) {
  return Drawer(
    child: ListView(padding: EdgeInsets.zero, children: milistview(context)),
  );
}

Widget respuesta(String contenido) {
  return Text(contenido, style: TextStyle(color: Colors.red, fontSize: 15));
}

Widget errorsobre(String rest, int numero) {
  int minvalor = 5;

  if (rest.length == 0 && numero == 0) {
    return Container();
  }

  if (rest.length == 0 && numero != 0) {
    return respuesta("Es necesario ingresar el código del sobre");
  }

  if (rest.length > 0 && rest.length < minvalor) {
    return respuesta("La longitud mínima es de $minvalor caracteres");
  }

  return FutureBuilder(
      future: envioController.validarexistencia(rest),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          final validador = snapshot.data;
          if (!validador) {
            return respuesta("El código no existe");
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      });

  //return Container();
}

Widget errorbandeja(String rest, int numero) {
  int minvalor = 5;

  if (rest.length == 0 && numero == 0) {
    return Container();
  }

  if (rest.length > 0 && rest.length < minvalor) {
    return respuesta("La longitud mínima es de $minvalor caracteres");
  }
/*
  if(envioController.validarexistenciabandeja(rest) && rest.length>0 ){
      return respuesta("El código no existe");
  }*/

  return Container();
}

List<Widget> milistview(BuildContext context) {
  List<Widget> list = new List<Widget>();

  final _prefs = new PreferenciasUsuario();
  if (_prefs.token != "") {
    Menu menuu = new Menu();
    String menuinicio = "";
    List<dynamic> menus = json.decode(_prefs.menus);
    List<Menu> listmenu = menuu.fromPreferencs(menus);
    for (Menu men in listmenu) {
      if (men.home) {
        menuinicio = men.link;
      }
    }
    listmenu.sort((a, b) => a.orden.compareTo(b.orden));
    listmenu.reversed;
    list.add(DrawerHeader(
      child: Container(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/original.jpg'), fit: BoxFit.cover)),
    ));
    for (Menu men in listmenu) {
      list.add(ListTile(
          leading: getICon(men.icono),
          title: Text(men.nombre),
          onTap: () => Navigator.of(context).pushNamed(men.link)));
      /* Navigator.of(context).pushNamedAndRemoveUntil(
                men.link, ModalRoute.withName('/principal-admin'))));*/

    }

    if (_prefs.buzon != "") {
      list.add(menuOpcion(context));
      list.add(cerrarsesion(context));
    }
  }
  return list;
}

Widget menuOpcion(BuildContext context) {
  final _prefs = new PreferenciasUsuario();
  if (tipoPerfil(_prefs.perfil) == cliente) {
    dynamic buzon = json.decode(_prefs.buzon);
    return ListTile(
        leading: Icon(Icons.assignment_ind, color: Colors.blue),
        title: Text(buzon["nombre"]),
        onTap: () {
          modificarUtdOrBuzon(context, cliente);
        });
  } else {
    dynamic utd = json.decode(_prefs.utd);
    return ListTile(
        leading: Icon(Icons.business, color: Colors.blue),
        title: Text(utd["nombre"]),
        onTap: () {
          modificarUtdOrBuzon(context, exact);
        });
  }
}

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
        decoration: myBoxDecoration(colorletra),
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
                      style: TextStyle(color: colorletra, fontSize: 12),
                    ),
                  )),
              onTap: () async {
                bool respuestabool = await confirmacion(
                    context, "success", "EXACT", "¿Seguro que desea continua?");
                if (respuestabool != null) {
                  if (respuestabool) {
                    /*       eventNotifier.value += 1; */
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
              ? "Seleccione un nuevo buzon"
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

Widget cerrarsesion(BuildContext context) {
  return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.blue),
      title: Text("Cerrar Sesión"),
      onTap: () {
        eliminarpreferences(context);
      });
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

final _icons = <String, IconData>{
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
  'historico': Icons.history
};

Icon getICon(String nombreIcono) {
  return Icon(_icons[nombreIcono], color: Colors.blue);
}

void redirection(BuildContext context, String ruta) {
  Navigator.pushReplacementNamed(context, ruta);
}

////////////

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

Widget crearTitulo(String titulo) {
  return AppBar(
      backgroundColor: primaryColor,
      title: Text(titulo,
          style: TextStyle(
              fontSize: 18,
              decorationStyle: TextDecorationStyle.wavy,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal)));
}

final primaryColor = Color(0xFF2C6983);
final colorletra = Color(0xFFACADAD);
final colorplomo = Color(0xFFEAEFF2);
final colorblanco = Color(0xFFFFFFFF);

Future<String> getDataFromCamera() async {
  String qrbarra =
      await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
  return qrbarra;
}

BoxDecoration myBoxDecoration(Color colorletra) {
  return BoxDecoration(
    border: Border.all(color: colorletra),
  );
}
