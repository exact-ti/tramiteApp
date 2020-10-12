import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'NuevaEntregaExternaController.dart';
import 'package:tramiteapp/src/Util/modals/confirmationArray.dart';

class NuevoEntregaExternaPage extends StatefulWidget {
  @override
  _NuevoEntregaExternaPageState createState() =>
      new _NuevoEntregaExternaPageState();
}

class _NuevoEntregaExternaPageState extends State<NuevoEntregaExternaPage> {
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = [];
  List<EnvioModel> listaEnviosValidados = [];
  List<EnvioModel> listaEnviosNoValidados = new List();
  NuevoEntregaExternaController principalcontroller =
      new NuevoEntregaExternaController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  int cantidadPendientes = 0;
  int cantidadInicial = 0;
  List<String> listaCodigosValidados = new List();
  bool inicio = true;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  var colorletra = const Color(0xFFACADAD);
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    listarNovalidados() {
      for (EnvioModel envio in listaEnvios) {
        if (listaCodigosValidados.contains(envio.codigoPaquete)) {
          listaEnviosValidados.add(envio);
        } else {
          listaEnviosNoValidados.add(envio);
        }
      }
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 150.0,
          height: 50.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () async {
                listarNovalidados();
                if (listaEnviosNoValidados.length == 0) {
                  principalcontroller.confirmacionDocumentosValidadosEntrega(
                      listaEnviosValidados, context, codigoBandeja);
                } else {
                  bool respuestaarray = await confirmarArray(
                      context,
                      "success",
                      "EXACT",
                      "Te faltan asociar estos documentos",
                      listaEnviosNoValidados);
                  if (respuestaarray == null) {
                    listaEnviosNoValidados.clear();
                    listaEnviosValidados.clear();
                    Navigator.of(context).pop();
                  } else {
                    if (respuestaarray) {
                      principalcontroller
                          .confirmacionDocumentosValidadosEntrega(
                              listaEnviosValidados, context, codigoBandeja);
                    } else {
                      listaEnviosNoValidados.clear();
                      listaEnviosValidados.clear();
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              color: Color(0xFF2C6983),
              child: Text('Registrar', style: TextStyle(color: Colors.white))),
        ));

    void _validarSobreText(String value) async {
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
          });
          enfocarInputfx(context, f2);
        } else {
          EnvioModel enviocontroller = await principalcontroller
              .validarCodigoEntrega(_bandejaController.text, value, context);
          if (enviocontroller != null) {
            setState(() {
              listaEnvios.add(enviocontroller);
              listaCodigosValidados.add(value);
            });
            popuptoinput(
                context, f2, "success", "EXACT", "Envío agregado a la entrega");
          } else {
            popuptoinput(context, f2, "error", "EXACT",
                "No es posible procesar el código");
          }
        }
      } else {
        popuptoinput(context, f2, "error", "EXACT",
            "El campo del sobre no puede ser vacío");
      }
    }

    void validarLista(String codigo) async {
      EnvioModel envioModel = new EnvioModel();
      String dataString = "";
      dynamic respuestalist =
          await principalcontroller.listarEnviosEntrega(context, codigo);
      if (respuestalist["status"] == "success") {
        dynamic datapalomar = respuestalist["data"];
        listaEnvios = envioModel.fromJsonValidar(datapalomar);
      } else {
        dataString = respuestalist["message"];
        listaEnvios = [];
      }
      if (listaEnvios.length != 0) {
        setState(() {
          codigoSobre = "";
          listaEnvios = listaEnvios;
          listaCodigosValidados.clear();
          _sobreController.text = "";
          codigoBandeja = codigo;
          _bandejaController.text = codigo;
        });
        enfocarInputfx(context, f2);
      } else {
        setState(() {
          listaCodigosValidados.clear();
          _sobreController.text = "";
          codigoSobre = "";
          listaEnvios = [];
          codigoBandeja = codigo;
          _bandejaController.text = codigo;
        });
        popuptoinput(
            context,
            f1,
            "error",
            "EXACT",
            dataString.length == 0
                ? "No cuenta con envíos asociados"
                : dataString);
      }
    }

    void _validarBandejaText(String value) {
      if (value != "") {
        validarLista(value);
      } else {
        setState(() {
          listaEnvios.clear();
          listaCodigosValidados.clear();
          _sobreController.text = "";
          codigoSobre = "";
        });
        popuptoinput(
            context, f1, "error", "EXACT", "La bandeja es obligatoria");
      }
    }

    final textBandeja = Container(
      child: Text("Código de valija"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código de envío"),
      margin: const EdgeInsets.only(left: 15),
    );

    void agregaralista(EnvioModel envio) {
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {
        if (!listaEnvios.contains(envio)) {
          listaEnvios.add(envio);
        }
      }
    }

    Widget crearItem(EnvioModel envio, List<String> validados, int i) {
      String codigopaquete = envio.codigoPaquete;
      bool estado = false;
      if (validados.length != 0) {
        for (String codigovalidado in validados) {
          if (codigovalidado == envio.codigoPaquete) {
            estado = true;
          }
        }
      }
      if (i == 1) {
        agregaralista(envio);
      }
      if (estado) {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading:
                  FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
              trailing: Icon(
                Icons.check,
                color: Color(0xffC7C7C7),
              ),
            ));
      } else {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading:
                  FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
              trailing: Text(""),
            ));
      }
    }

    Future _traerdatosescanerSobre() async {
      qrbarra = await getDataFromCamera();
      if (_bandejaController.text == "") {
        _sobreController.text = "";
        popuptoinput(context, f1, "error", "EXACT",
            "Primero debe ingresar el codigo de la bandeja");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra = await getDataFromCamera();
      _validarBandejaText(qrbarra);
    }

    Widget _crearListadoinMemoria(
        List<String> validados, List<EnvioModel> envios) {
      return ListView.builder(
          itemCount: envios.length,
          itemBuilder: (context, i) => crearItem(envios[i], validados, 0));
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f1,
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
      focusNode: f2,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoBandeja == "") {
          _sobreController.text = "";
          notificacion(context, "error", "EXACT",
              "Primero debe ingresar el codigo de la bandeja");
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

    Widget _validarListado(List<String> validados, List<EnvioModel> envios) {
      return _crearListadoinMemoria(validados, envios);
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
        appBar: CustomAppBar(text: "Entregas externas"),
        drawer: DrawerPage(),
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
                            child: textBandeja),
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
                            child: textSobre),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoSobre,
                          margin: const EdgeInsets.only(bottom: 30),
                        ),
                      ),
                      Expanded(
                          child: codigoBandeja == ""
                              ? Container()
                              : Container(
                                  child: _validarListado(
                                      listaCodigosValidados, listaEnvios))),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 5),
                            width: double.infinity,
                            child: sendButton),
                      ),
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
