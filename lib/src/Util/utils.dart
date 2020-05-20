import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

EnvioController envioController = new EnvioController();

void mostrarAlerta(BuildContext context, String mensaje, String titulo) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$titulo'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Future<bool> confirmarRespuesta(
    BuildContext context, String title, String description) async {
  bool respuesta = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
                // Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
                // Navigator.of(context).pop();
                return false;
              },
              child: Text('Cancelar'),
            )
          ],
        );
      });

  return respuesta;
}

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
    List<dynamic> menus = json.decode(_prefs.menus);
    List<Menu> listmenu = menuu.fromPreferencs(menus);
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
          leading:  getICon(men.icono),
          title: Text(men.nombre),
          onTap: () => Navigator.pushReplacementNamed(context, men.link)));
    }

    if (_prefs.buzon != "") {
      list.add(cerrarsesion(context));
    }
  }
  return list;
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
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      (Route<dynamic> route) => false);
}

final _icons = <String, IconData>{
  'home': Icons.home,
  'envio': Icons.send,
  'recorrido': Icons.directions_run,
  'importar': Icons.file_upload,
  'custodiar': Icons.check_box,
  'clasificar': Icons.sort,
  'intersede': Icons.transfer_within_a_station,
  'revalija': Icons.markunread,
  'lote': Icons.check_box_outline_blank,
  'relote': Icons.filter_none,
  'agencia': Icons.airline_seat_recline_normal,
  'recepcion': Icons.receipt,
  'consulta': Icons.record_voice_over,
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

void trackingPopUp(BuildContext context, int codigo) async {
  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());
  double heightCel = 0.6 * (MediaQuery.of(context).size.height);
String observacion ="";
  TrackingModel trackingModel = await trackingCore.mostrarTracking(codigo);

  List<Widget> listadecodigos = new List();

  for (TrackingDetalleModel detalle in trackingModel.detalles) {
    
    listadecodigos.add(Container(
        decoration: myBoxDecoration(colorletra),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                detalle.fecha,
                style: TextStyle(color: colorletra, fontSize: 12),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.remitente,
                  style: TextStyle(color: colorletra, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.sede,
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
          ],
        )));
  }

  if(trackingModel.observacion!=null){
      observacion=trackingModel.observacion;
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
          height: heightCel,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Código',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.codigo,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('De',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.remitente,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Origen',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.origen,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Para',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.destinatario,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Destino',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(
                            trackingModel.destino,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Observación',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(observacion,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: listadecodigos))),
              /*Container(
             height: 20,   
            child:ListView(
              children:listadecodigos,
            )
              )*/
            ],
          ),
        ));
      });
}
