import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';

import 'RecepcionController.dart';

class RecepcionEntregaLotePage extends StatefulWidget {
  final EntregaLoteModel entregaLotepage;

  const RecepcionEntregaLotePage({Key key, this.entregaLotepage})
      : super(key: key);

  @override
  _RecepcionEntregaLotePageState createState() =>
      new _RecepcionEntregaLotePageState(entregaLotepage);
}

class _RecepcionEntregaLotePageState extends State<RecepcionEntregaLotePage> {
  EntregaLoteModel entregaLote;
  _RecepcionEntregaLotePageState(this.entregaLote);
  RecepcionControllerLote principalcontroller = new RecepcionControllerLote();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  String qrsobre, qrbarra = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  var listadetinatario;
  var colorletra = const Color(0xFFACADAD);

  @override
  void initState() {
    if (entregaLote != null) {
      _bandejaController.text = entregaLote.paqueteId;
      codigoBandeja = entregaLote.paqueteId;
      iniciarlistaEnvios();
    } else {
      listaEnvios = [];
    }
    super.initState();
  }

  void iniciarlistaEnvios() async {
    listaEnvios =
        await principalcontroller.listarEnviosLotes(context, codigoBandeja);
    setState(() {
      listaEnvios = listaEnvios;
    });
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    contieneCodigo(codigo) async {
      bool pertenecia = false;
      for (EnvioModel envio in listaEnvios) {
        if (envio.codigoPaquete == codigo) {
          pertenecia = true;
        }
      }
      if (pertenecia == true) {
        bool respuesta = await principalcontroller.recogerdocumentoLote(
            context, codigoBandeja, codigo);
        if (respuesta) {
          listaEnvios.removeWhere((value) => value.codigoPaquete == codigo);
          if (listaEnvios.length == 0) {
            confirmarRecepcion(
                context, "Mensaje", "Se ha completado la recepción");
            setState(() {
              listaEnvios = listaEnvios;
            });
          } else {
            setState(() {
              listaEnvios = listaEnvios;
            });
          }
        } else {
          mostrarAlerta(
              context, "No se pudo completar la operación", "Mensaje");
        }
      } else {
        bool respuesta = await principalcontroller.recogerdocumentoLote(
            context, codigoBandeja, codigo);
        if (respuesta) {
          mostrarAlerta(context, "Se registro el código", "Mensaje");
        } else {
          mostrarAlerta(context, "No es posible procesar el código", "Mensaje");
        }
      }
    }

    void _validarSobreText(String value) {
      if (value != "") {
        contieneCodigo(value);
      } else {
        mostrarAlerta(context, "El código es obligatorio", "Mensaje");
      }
    }

    void _validarBandejaText(String value) async {
      if (value != "") {
        listaEnvios =
            await principalcontroller.listarEnviosLotes(context, codigoBandeja);
        if (listaEnvios != null) {
          setState(() {
            codigoBandeja = value;
            _bandejaController.text = value;
            listaEnvios = listaEnvios;
          });
        } else {
          setState(() {
            listaEnvios = [];
          });
          mostrarAlerta(context, "No contiene envíos", "Mensaje");
        }
      } else {
        setState(() {
          listaEnvios = [];
        });
        mostrarAlerta(
            context, "El campo de la bandeja no puede estar vacío", "Mensaje");
      }
    }

    void agregaralista(EnvioModel envio) {
      bool pertenece = false;
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {
        for (EnvioModel envioModel in listaEnvios) {
          if (envioModel.id == envio.id) {
            pertenece = true;
          }
        }
        if (!pertenece) {
          //setState(() {
          listaEnvios.add(envio);
          //});
        }
      }
    }

    Widget crearItem(EnvioModel envio) {
      String codigopaquete = envio.codigoPaquete;
      agregaralista(envio);

      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            title: Text("$codigopaquete"),
            leading: FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
            trailing: Text(""),
          ));
    }

    Future _traerdatosescanerSobre() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (codigoBandeja == "") {
        _sobreController.text = "";
        mostrarAlerta(context, "Primero debe ingresar el codigo de la bandeja",
            "Ingreso incorrecto");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarBandejaText(qrbarra);
    }

    Widget sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              confirmarPendientes(
                  context, "Te faltan asociar estos documentos", listaEnvios);
            },
            color: Color(0xFF2C6983),
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Terminar', style: TextStyle(color: Colors.white)),
          ),
        ));

    Widget _crearListadoinMemoria(List<EnvioModel> envios) {
      return ListView.builder(
          itemCount: envios.length,
          itemBuilder: (context, i) => crearItem(envios[i]));
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _validarBandejaText(value);
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

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoBandeja == "") {
          _sobreController.text = "";
          mostrarAlerta(
              context,
              "Primero debe ingresar el codigo de la bandeja",
              "Ingreso incorrecto");
        } else {
          _validarSobreText(value);
        }
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

    Widget _validarListado(List<EnvioModel> envios) {
      return _crearListadoinMemoria(envios);
    }

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: bandeja,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerBandeja),
        ),
      ),
    ]);

    final campodetextoandIconoSobre = Row(children: <Widget>[
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
              onPressed: _traerdatosescanerSobre),
        ),
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
          title: Text('Recibir Lotes',
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: principalcontroller.labeltext("Lote")),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoBandeja),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            //width: double.infinity,
                            child: principalcontroller.labeltext("Valija")),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoSobre,
                          margin: const EdgeInsets.only(bottom: 40),
                        ),
                      ),
                      Expanded(child: _validarListado(listaEnvios)),
                      listaEnvios.length != 0
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeightExcludingToolbar(context,
                                      dividedBy: 5),
                                  width: double.infinity,
                                  child: sendButton),
                            )
                          : Container(),
                    ],
                  ),
                ))));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  void confirmarNovalidados(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    Widget informacion = principalcontroller.contenidoPopUp(
        colorletra, novalidados, novalidados.length);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: informacion,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Descartar pendientes'),
                  onPressed: () {
                    listaEnvios.clear();
                    _bandejaController.text = "";
                    codigoBandeja = "";
                    _sobreController.text = "";
                    codigoSobre = "";
                    Navigator.of(context).pop();
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                  child: Text('Volver a leer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void confirmarRecepcion(BuildContext context, String titulo, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: Text('$mensaje'),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/envio-lote');
                  })
            ],
          );
        });
  }

  void confirmarPendientes(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    Widget informacion = principalcontroller.contenidoPopUp(
        colorletra, novalidados, novalidados.length);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: informacion,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Descartar pendientes'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/envio-lote');
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                  child: Text('Volver a leer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
