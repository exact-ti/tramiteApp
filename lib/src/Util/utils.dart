import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
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

Future<bool> confirmarRespuesta(BuildContext context, String title, String description) async {
   
  

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
              Navigator.pop(context,true);
              // Navigator.of(context).pop();
            }, 
            child: Text('Aceptar'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context,false);
              // Navigator.of(context).pop();
              return false;
            },
            child: Text('Cancelar'),
          )
        ],
      );
    }
  );

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
  if(_prefs.token!=""){
  Menu menuu = new Menu();
  List<dynamic> menus = json.decode(_prefs.menus);
  List<Menu> listmenu = menuu.fromPreferencs(menus);
  list.add(DrawerHeader(
    child: Container(),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/original.jpg'), fit: BoxFit.cover)),
  ));
  for (Menu men in listmenu) {
    list.add(ListTile(
        leading: Icon(Icons.pages, color: Colors.blue),
        title: Text(men.nombre),
        onTap: () => Navigator.pushReplacementNamed(context, men.link)));
  }
  }
  return list;
}


final _icons= <String, IconData>{
  'add_alert'     : Icons.add_alert,
  'accessibility' : Icons.accessibility,
  'folder_open'   : Icons.folder_open,
};


Icon getICon ( String nombreIcono){
  return Icon(_icons[nombreIcono],color: Colors.blue);
}


void redirection(BuildContext context, String ruta){
Navigator.pushReplacementNamed(context,ruta);
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
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }


<<<<<<< HEAD
Widget crearTitulo(String titulo){
  return AppBar(
    backgroundColor: primaryColor,
    title: Text(titulo,
      style: TextStyle(
        fontSize: 18,
        decorationStyle: TextDecorationStyle.wavy,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal
      )
    )
  );
}

final  primaryColor = Color(0xFF2C6983);
final  colorletra = Color(0xFFACADAD);
final colorplomo = Color(0xFFEAEFF2);
final colorblanco = Color(0xFFFFFFFF);

Future<String> getDataFromCamera() async {
  String qrbarra = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
  return qrbarra;
}
=======
  BoxDecoration myBoxDecoration(Color colorletra) {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }
>>>>>>> c2ecc6d1cff7d7404074233279653c8cc805a44f
