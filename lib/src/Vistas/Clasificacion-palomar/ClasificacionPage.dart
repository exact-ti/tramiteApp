import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';

import 'ClasificacionController.dart';

class ClasificacionPage extends StatefulWidget {
  @override
  _ClasificacionPageState createState() => _ClasificacionPageState();
}

class _ClasificacionPageState extends State<ClasificacionPage> {
  ClasificacionController principalcontroller = new ClasificacionController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, _label, valuess = "";
  String codigoValidar = "";
  final _sobreController = TextEditingController();
  var listadestinatarios;
  String textdestinatario = "";

  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;

  var nuevo = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);
    var booleancolor = true;
    var colorwidget = colorplomo;

    void _validarText(String value) {
      if (value != "") {
        setState(() {
          _sobreController.text = value;
          codigoValidar = value;
     });
      }
    }

    Widget crearItem(PalomarModel palomar) {
      String codigopalomar = palomar.codigo;
      String tipo = palomar.tipo;
      int fila = palomar.fila;
      int columna = palomar.columna;
      return Container(
          child: new Column(
        children: <Widget>[
          //Text("Este documento va para el palomar $codigopalomar"),
          /*Center(
            child: RichText(
              text: TextSpan(
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                      text: 'Este documento va para el palomar',
                      style: TextStyle(color: Colors.black,fontSize: 17)),
                  TextSpan(
                      text: ' $codigopalomar',
                      style: TextStyle(color: Colors.blue,fontSize: 17)),
                ],
              ),
            ),
          ),*/
          //Text("Este documento va para el palomar Fila $fila - Columna $columna"),

          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child:
                          Text('Palomar', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('$codigopalomar',
                        style: TextStyle(color: Colors.blue)),
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
                      alignment: Alignment.centerRight,
                      child: Text('Tipo', style: TextStyle(color: Colors.black)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('$tipo', style: TextStyle(color: Colors.blue)),
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
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Ubicación',
                          style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('Columna $columna Fila $fila',
                        style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              ))
        ],
      ));
    }

    Widget _crearcontenido(String codigo) {

      booleancolor = true;
      colorwidget = colorplomo;
      if(codigoValidar!=""){
      codigoValidar="";
      return FutureBuilder(
          future:
              principalcontroller.listarpalomarByCodigo(context, codigo),
          builder: (BuildContext context,
              AsyncSnapshot<List<PalomarModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
              final palomares = snapshot.data;
              return ListView.builder(
                  itemCount: palomares.length,
                  itemBuilder: (context, i) => crearItem(palomares[i]));
            } else {
              return Container();
            }
          });
      }

    }

    final sendButton = Container(
      //margin: const EdgeInsets.only(top: 10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          //Navigator.of(context).pushNamed('/entregas-pisos-propios');
        },
        color: Color(0xFF2C6983),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: Text('Cambiar Forma',
            style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );

    const PrimaryColor = const Color(0xFF2C6983);

    final titulotext = Text('Clasificar documento en palomar',
        style: TextStyle(
            fontSize: 22, color: PrimaryColor, fontWeight: FontWeight.bold));

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.center,
      onFieldSubmitted: (value) {
        _validarText(value);
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
        hintText: 'Ingrese codigo',
      ),
    );

    Future _traerdatosescanerbandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarText(qrbarra);
    }

    final campodetextoandIcono = Row(children: <Widget>[
      Expanded(
        child: sobre,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerbandeja),
        ),
      ),
    ]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          title: Text('Dejar documento en palomar',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: sd.crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /* Align(
                alignment: Alignment.centerRight,
                child: Container(
                    alignment: Alignment.centerRight,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    child: sendButton),
              ),*/
              /* Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: titulotext),
              ),*/
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child: campodetextoandIcono),
              ),
              Expanded(
                child: _sobreController.text == ""
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.bottomCenter,
                        child: _crearcontenido(codigoValidar)),
              )
            ],
          ),
        ));
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
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
}
