import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';

import 'ConsultaEnvioController.dart';

class ConsultaEnvioPage extends StatefulWidget {
  @override
  _ConsultaEnvioPageState createState() => new _ConsultaEnvioPageState();
}

class _ConsultaEnvioPageState extends State<ConsultaEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<TurnoModel> listaTurnos = new List();
  List<EnvioModel> listaEnviosVacios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  ConsultaEnvioController principalcontroller = new ConsultaEnvioController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoPaquete = "";
  String codigoDestinatario = "";
  String codigoremitente = "";
  int cantidadPendientes = 0;
  int cantidadInicial = 0;
  String selectedFc;
  List<String> listaCodigosValidados = new List();
  bool activo = false;
  bool button = false;
  FocusNode _focusNode;
  FocusNode f1paquete = FocusNode();
  FocusNode f2remitente = FocusNode();
  FocusNode f3destinatario = FocusNode();
  var colorletra = const Color(0xFFACADAD);
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _paqueteController.clear();
    });
    super.initState();
    listaEnviosVacios = [];
    listaTurnos = [];
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    listarNovalidados() {
      bool esvalidado = false;
      List<dynamic> as = listaEnvios;
      List<dynamic> ads = listaCodigosValidados;
      for (EnvioModel envio in listaEnvios) {
        if (listaCodigosValidados.contains(envio.codigoPaquete)) {
          listaEnviosValidados.add(envio);
        } else {
          listaEnviosNoValidados.add(envio);
        }
      }
    }

    void listarEnvios(String paquete, String remitente, String destinatario,
        bool opcion) async {
      listaEnvios = await principalcontroller.listarEnvios(
          context, paquete, remitente, destinatario, opcion);
      if (listaEnvios != null) {
        setState(() {
          listaEnvios = listaEnvios;
        });
      } else {
        listaEnvios = [];
        setState(() {
          listaEnvios = listaEnvios;
        });
      }
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              if (_paqueteController.text == "" &&
                  _remitenteController.text == "" &&
                  _destinatarioController.text == "") {
                notificacion(context, "error", "EXACT",
                    "Se debe llenar al menos un campo");
                setState(() {
                  button = false;
                  listaEnvios = [];
                });
              } else {
                setState(() {
                  button = true;
                });
                listarEnvios(
                    codigoPaquete, codigoremitente, codigoDestinatario, activo);
              }
            },
            color: Color(0xFF2C6983),
            child: Text('Buscar', style: TextStyle(color: Colors.white)),
          ),
        ));

    /*void _validarSobreText(String value) {
      if (value != "") {
        bool perteneceLista = false;
        for (EnvioModel envio in listaEnvios) {
          if (envio.codigoPaquete == value) {
            perteneceLista = true;
          }
        }
        if (perteneceLista) {
          setState(() {
            _sobreController.text = "";
            codigoSobre = value;
            listaCodigosValidados.add(value);
            codigoBandeja = _bandejaController.text;
          });
        } else {
          setState(() {
            _sobreController.text = "";
            codigoSobre = value;
            codigoBandeja = _bandejaController.text;
          });
        }
      }
    }*/

    void _validarPaqueteText(String value) async {
      codigoPaquete = value;
      _paqueteController.text = value;
      enfocarInputfx(context, f2remitente);
    }

    void _validarRemitenteText(String value) async {
      codigoremitente = value;
      _remitenteController.text = value;
      enfocarInputfx(context, f3destinatario);
    }

    void _validarDestinatarioText(String value) async {
      codigoDestinatario = value;
      _destinatarioController.text = value;
    }

    final textPaquete = Container(
      child: Text("Código de paquete"),
    );

    final textRemitente = Container(
      child: Text("De"),
    );

    final textDestinatario = Container(
      child: Text("Para"),
    );

    Widget crearItem(EnvioModel envio, int i) {
      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text('De',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(envio.remitente,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text('para',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(envio.destinatario,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: new GestureDetector(
                              onTap: () {
                                trackingPopUp(context, envio.id);
                              },
                              child: Text(envio.codigoPaquete,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)),
                            )),
                        flex: 3,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                              "En custodia en UTD " + envio.codigoUbicacion,
                              style: TextStyle(color: Colors.black)),
                        ),
                        flex: 6,
                      ),
                    ],
                  )),
            ],
          ));
    }

    Future _traerdatosescanerPaquete() async {
      qrbarra = await getDataFromCamera();
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      _validarPaqueteText(qrbarra);
    }

    var paquete = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f1paquete,
      controller: _paqueteController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        _validarPaqueteText(value);
      },
      onChanged: (text) {
        codigoPaquete = text;
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
      ),
    );

    var remitente = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f2remitente,
      controller: _remitenteController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        _validarRemitenteText(value);
      },
      onChanged: (text) {
        codigoremitente = text;
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
      ),
    );

    var destinatario = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f3destinatario,
      controller: _destinatarioController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        _validarDestinatarioText(value);
      },
      onChanged: (text) {
        codigoDestinatario = text;
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
      ),
    );

    Widget _crearListadoAgregar(List<EnvioModel> lista) {
      if (lista.length == 0) {
        return Container();
      }

      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i], 1));
    }

    final campodetextoandIconoDestinatario = Row(children: <Widget>[
      Expanded(
        child: destinatario,
        flex: 5,
      ),
      Expanded(
        child: Opacity(
            opacity: 0.0,
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Icon(Icons.camera_alt),
            )),
      ),
    ]);

    final campodetextoandIconoPaquete = Row(children: <Widget>[
      Expanded(
        child: paquete,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerPaquete),
        ),
      ),
    ]);

    final campodetextoandIconoRemitente = Row(children: <Widget>[
      Expanded(
        child: remitente,
        flex: 5,
      ),
      Expanded(
        child: Opacity(
            opacity: 0.0,
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Icon(Icons.camera_alt),
            )),
      ),
    ]);

    Widget mostrarText(bool opcion) {
      return Container(
          child: new GestureDetector(
        onTap: () {
          if (opcion) {
            listarEnvios(
                codigoPaquete, codigoremitente, codigoDestinatario, false);
            setState(() {
              activo = false;
            });
          } else {
            listarEnvios(
                codigoPaquete, codigoremitente, codigoDestinatario, true);
            setState(() {
              activo = true;
            });
          }
        },
        child: opcion == false
            ? Text(
                "Mostrar inactivos",
                style: TextStyle(color: Colors.grey),
              )
            : Text(
                "Mostrar activos",
                style: TextStyle(color: Colors.blue),
              ),
      ));
    }

    final campodetextoandIconoButton = Row(children: <Widget>[
      Expanded(
        child: sendButton,
        flex: 5,
      ),
      Expanded(
        child: Opacity(
            opacity: 0.0,
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Icon(Icons.camera_alt),
            )),
      ),
    ]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Consultas',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: textPaquete),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoPaquete),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: textRemitente),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoRemitente),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            //width: double.infinity,
                            child: textDestinatario),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoDestinatario,
                          margin: const EdgeInsets.only(bottom: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoButton,
                        ),
                      ),
                      button == true
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: screenHeightExcludingToolbar(context,
                                    dividedBy: 12),
                                width: double.infinity,
                                child: mostrarText(activo),
                              ),
                            )
                          : Container(),
                      Expanded(
                          child: Container(
                              child: _crearListadoAgregar(listaEnvios))),
                    ],
                  ),
                ))));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
}

//                  Navigator.of(context).pushNamed(men.link);
