import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'RetirarEnvioController.dart';

class RetirarEnvioPage extends StatefulWidget {
  @override
  _RetirarEnvioPageState createState() => new _RetirarEnvioPageState();
}

class _RetirarEnvioPageState extends State<RetirarEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
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
  }

  void listarEnvios(String paquete, String remitente, String destinatario,
      bool opcion) async {
    listaEnvios = await principalcontroller.listarEnvios(
        context, paquete, remitente, destinatario, opcion);
    if (listaEnvios.isNotEmpty) {
      setState(() {
        listaEnvios = listaEnvios;
      });
    } else {
      setState(() {
        listaEnvios = [];
      });
    }
  }

  void buscarEnvios() {
    if (_paqueteController.text == "" &&
        _remitenteController.text == "" &&
        _destinatarioController.text == "") {
      notificacion(
          context, "error", "EXACT", "Se debe llenar al menos un campo");
      setState(() {
        button = false;
        listaEnvios = [];
      });
    } else {
      setState(() {
        button = true;
      });
      listarEnvios(codigoPaquete, codigoremitente, codigoDestinatario, activo);
    }
  }

  Future<bool> retirarEnvioController(
      EnvioModel envioModel, String motivo) async {
    dynamic respuesta =
        await principalcontroller.retirarEnvio(envioModel, motivo);
    desenfocarInputfx(context);
    if (respuesta.containsValue("success")) {
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      await notificacion(context, "success", "Exact", "Se retiró el envío");
      return true;
    } else {
      await notificacion(context, "Error", "Exact", respuesta["message"]);
      return false;
    }
  }

  Future<bool> retirarEnvioModal(BuildContext context, String tipo,
      String title, String description, EnvioModel envioModel) async {
    String mensajeError = "";
    final _observacionController = TextEditingController();
    bool respuesta = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('$title',
                        style: TextStyle(
                            color: tipo == "success"
                                ? Colors.blue[200]
                                : Colors.red[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 3.0,
                        color: tipo == "success"
                            ? Colors.blue[200]
                            : Colors.red[200]),
                  ),
                )),
            content: SingleChildScrollView(
                child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return new Column(mainAxisSize: MainAxisSize.min, children: <
                  Widget>[
                Container(
                  child: Text(description),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Ingrese el motivo:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                ),
                Container(
                  child: TextFormField(
                    maxLines: 6,
                    controller: _observacionController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEAEFF2),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xFFEAEFF2),
                          width: 0.0,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) async {
                      if (value.length == 0) {
                        setState(() {
                          mensajeError = "El mótivo del retiro es obligatorio";
                        });
                      } else {
                        bool respuesta = await retirarEnvioController(
                            envioModel, _observacionController.text);
                        if (respuesta) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    onChanged: (text) {
                      if (text.length == 0) {
                        setState(() {
                          mensajeError = "El mótivo del retiro es obligatorio";
                        });
                      } else {
                        setState(() {
                          mensajeError = "";
                        });
                      }
                    },
                  ),
                  padding: const EdgeInsets.only(right: 20, left: 20),
                ),
                mensajeError.length == 0
                    ? Container()
                    : Text(
                        mensajeError,
                        style: TextStyle(color: Colors.red),
                      ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              desenfocarInputfx(context);
                              if (_observacionController.text.length == 0) {
                                setState(() {
                                  mensajeError =
                                      "El mótivo del retiro es obligatorio";
                                });
                              } else {
                                bool respuesta = await retirarEnvioController(
                                    envioModel, _observacionController.text);
                                if (respuesta) {
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                            child: Center(
                                child: Container(
                                    height: 50.00,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 3.0,
                                              color: Colors.grey[100]),
                                          right: BorderSide(
                                              width: 1.5,
                                              color: Colors.grey[100])),
                                    ),
                                    child: Container(
                                      child: Text('Aceptar',
                                          style: _observacionController
                                                      .text.length ==
                                                  0
                                              ? TextStyle(color: Colors.grey)
                                              : TextStyle(color: Colors.black)),
                                    ))),
                          ),
                          flex: 5,
                        ),
                        Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Center(
                                  child: Container(
                                      height: 50.00,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 3.0,
                                                color: Colors.grey[100]),
                                            left: BorderSide(
                                                width: 1.5,
                                                color: Colors.grey[100])),
                                      ),
                                      child: Container(
                                        child: Text('Cancelar',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ))),
                            ))
                      ],
                    ))
              ]);
            })),
            contentPadding: EdgeInsets.all(0),
          );
        });

    if (respuesta == null) {
      respuesta = false;
    }
    return respuesta;
  }

  @override
  Widget build(BuildContext context) {
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
              desenfocarInputfx(context);
              buscarEnvios();
            },
            color: Color(0xFF2C6983),
            child: Text('Buscar', style: TextStyle(color: Colors.white)),
          ),
        ));

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
      String codigo = envio.codigoPaquete;
      return Container(
          decoration: myBoxDecoration(colorletra),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () async {
                bool respuestamodal = await retirarEnvioModal(
                    context,
                    "success",
                    "EXACT",
                    "¿Seguro que desea retirar el envío $codigo?",
                    envio);
                if (respuestamodal) {
                  desenfocarInputfx(context);
                  setState(() {
                    _paqueteController.text = "";
                    _remitenteController.text = "";
                    _destinatarioController.text = "";
                    listaEnvios = [];
                  });
                }
              },
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 20, left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('De',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(
                                envio.remitente == null
                                    ? "Envío importado"
                                    : envio.remitente,
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
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text('para',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
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
                                margin:
                                    const EdgeInsets.only(left: 10, bottom: 10),
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
                              child: Text(envio.observacion,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            flex: 6,
                          ),
                        ],
                      )),
                ],
              )));
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

    Widget mainscaffold() {
      return Padding(
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
                  height: screenHeightExcludingToolbar(context, dividedBy: 30),
                  width: double.infinity,
                  child: textPaquete),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoPaquete),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 30),
                  width: double.infinity,
                  child: textRemitente),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoRemitente),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 30),
                  //width: double.infinity,
                  child: textDestinatario),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.centerLeft,
                height: screenHeightExcludingToolbar(context, dividedBy: 12),
                width: double.infinity,
                child: campodetextoandIconoDestinatario,
                margin: const EdgeInsets.only(bottom: 20),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                height: screenHeightExcludingToolbar(context, dividedBy: 12),
                width: double.infinity,
                child: campodetextoandIconoButton,
              ),
            ),
            Expanded(
                child: Container(child: _crearListadoAgregar(listaEnvios))),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Retirar envío"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
