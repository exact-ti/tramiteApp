import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Util/widgets/testFormUppCase.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Listar-TipoPersonalizada/ListarTipoPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'EntregaRegularController.dart';

class EntregaRegularPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const EntregaRegularPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _EntregaRegularPageState createState() =>
      new _EntregaRegularPageState(recorridopage);
}

class _EntregaRegularPageState extends State<EntregaRegularPage> {
  RecorridoModel recorridoUsuario;
  _EntregaRegularPageState(this.recorridoUsuario);
  EntregaregularController envioController = new EntregaregularController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  EnvioModel envioModel = new EnvioModel();
  List<EnvioModel> listaenvios2 = new List();
  List<EnvioModel> listaEnvios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  EntregaregularController principalcontroller = new EntregaregularController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String mensaje = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  String textdestinatario = "";
  int numeroRecorrido;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  List<String> listaCodigosValidados = new List();
  bool inicio = true;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  var nuevo = 0;
  bool isSwitched = true;
  var validarSobre = false;
  var validarBandeja = false;
  bool confirmaciondeenvio = false;
  String codigoMostrar = '';
  int indice = 0;
  int indicebandeja = 0;
  @override
  void initState() {
    numeroRecorrido = recorridoUsuario.id;
    valuess = "";
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    void registrarDocumento(String documento) async {
      bool pertenecia = false;
      for (EnvioModel envio in listaenvios2) {
        if (envio.codigoPaquete == documento) {
          pertenecia = true;
        }
      }
      if (pertenecia == true) {
        if (isSwitched) {
          dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (respuestaMap.containsValue("success")) {
            dynamic respuestaMap2 = respuestaMap["data"];
            mensaje = respuestaMap2["destino"];
            listaenvios2
                .removeWhere((value) => value.codigoPaquete == documento);
            codigoMostrar = documento;
          } else {
            codigoMostrar = "";
            mensaje = respuestaMap["message"];
          }
        } else {
          dynamic respuestaMap = await envioController.recogerdocumentoEntrega(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (respuestaMap["status"] == "success") {
            listaenvios2
                .removeWhere((value) => value.codigoPaquete == documento);
            mensaje = "Se registró la entrega";
            codigoMostrar = documento;
          } else {
            codigoMostrar = "";
            mensaje = respuestaMap["message"];
          }
        }
        setState(() {
          codigoMostrar = documento;
          mensaje = mensaje;
          listaenvios2 = listaenvios2;
        });
      } else {
        if (isSwitched) {
          dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (respuestaMap.containsValue("success")) {
            dynamic respuestaMap2 = respuestaMap["data"];
            mensaje = respuestaMap2["destino"];
            codigoMostrar = documento;
          } else {
            codigoMostrar = "";
            mensaje = respuestaMap["message"];
          }
          setState(() {
            codigoMostrar = codigoMostrar;
            mensaje = mensaje;
          });
        } else {
          dynamic respuestaMap = await envioController.recogerdocumentoEntrega(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (respuestaMap["status"] == "success") {
            setState(() {
              codigoMostrar = documento;
              mensaje = "Se registró la entrega";
            });
          } else {
            setState(() {
              codigoMostrar = "";
              mensaje = respuestaMap["message"];
            });
          }
        }
      }
      enfocarInputfx(context, f2);
    }

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
          });
        } else {
          setState(() {
            _sobreController.text = "";
          });
        }
        registrarDocumento(value);
      } else {
        bool respuesta = await notificacion(
            context, "error", "EXACT", "Ingrese el codigo de sobre");
        if (respuesta = null || respuesta) {
          enfocarInputfx(context, f2);
        }
      }
    }

    void _validarBandejaText(String value) async {
      if (value != "") {
        if (isSwitched) {
          listaenvios2 = await principalcontroller.listarEnviosRecojo(
              context, recorridoUsuario.id, value);
          if (listaenvios2 == null) {
            /*  bool respuestatrue = await  */ notificacion(context, "error",
                "EXACT", "El código no existe en la base de datos");
/*             if (respuestatrue == null || respuestatrue) {
              enfocarInputfx(context, f1); */
            setState(() {
              mensaje = "";
              listaenvios2 = [];
              _bandejaController.text = value;
            });
            enfocarInputfx(context, f1);
/*             } */
          } else {
            if (listaenvios2.length == 0) {
              if (isSwitched) {
                bool respuestatrue = await notificacion(context, "error",
                    "EXACT", "No tiene envíos por recoger en el área");
                if (respuestatrue == null || respuestatrue == true) {
                  enfocarInputfx(context, f1);
                }
              } else {
                bool respuestatrue = await notificacion(context, "error",
                    "EXACT", "No tiene envíos por entregar en el área");
                if (respuestatrue == null || respuestatrue == true) {
                  enfocarInputfx(context, f1);
                }
              }
              setState(() {
                mensaje = "";
                listaenvios2 = [];
                _bandejaController.text = value;
              });
            } else {
              enfocarInputfx(context, f2);
              setState(() {
                mensaje = "";
                codigoBandeja = value;
                _bandejaController.text = value;
              });
            }
          }
        } else {
          dynamic respuesta = await principalcontroller.listarEnviosEntrega(
              context, recorridoUsuario.id, value);
          if (respuesta["status"] == "success") {
            listaenvios2 = envioModel.fromJsonValidar(respuesta["data"]);
            enfocarInputfx(context, f2);
            setState(() {
              listaenvios2 = listaenvios2;
              codigoBandeja = value;
              _bandejaController.text = value;
            });
          } else {
            setState(() {
              listaenvios2 = [];
              codigoBandeja = "";
              _bandejaController.text = "";
            });
            bool respuestatrue = await notificacion(
                context, "error", "EXACT", respuesta["message"]);
            if (respuestatrue == null || respuestatrue == true) {
              enfocarInputfx(context, f1);
            }
          }
        }
      }
    }

    final botonesinferiores = Row(children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListarTipoPersonalizadaPage(),
              ),
            );
          },
          child: Text(
            'Entrega Personalizada',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        flex: 5,
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            envioController.redirectMiRuta(recorridoUsuario, context);
          },
          child: Text(
            'Mi ruta',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    ]);

    final valorswitch = Center(
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            _sobreController.text = "";
            _bandejaController.text = "";
            listaEnvios.clear();
            listaEnviosValidados.clear();
            listaEnviosNoValidados.clear();
            codigoValidar = "";
            codigoBandeja = "";
            codigoSobre = "";
            textdestinatario = "";
            listaCodigosValidados.clear();
            isSwitched = value;
            mensaje = "";
            codigoMostrar = "";
          });
        },
        activeTrackColor: SecondColor,
        activeColor: PrimaryColor,
      ),
    );

    final textBandeja = Container(
      child: Text("Código de bandeja"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código de sobre"),
      margin: const EdgeInsets.only(left: 15),
    );

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
      qrbarra = await getDataFromCamera();
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      if (codigoBandeja == "") {
        _sobreController.text = "";
        bool respuesta = await notificacion(context, "error", "EXACT",
            "Primero debe ingresar el codigo de la bandeja");
        if (respuesta == null || respuesta) {
          enfocarInputfx(context, f1);
        }
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra = await getDataFromCamera();
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      _validarBandejaText(qrbarra);
    }

    Widget _crearListadoinMemoria(List<EnvioModel> lista) {
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i]));
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f1,
      controller: _bandejaController,
      textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
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
      onFieldSubmitted: (value) async {
        if (_bandejaController.text == "") {
          _sobreController.text = "";
          bool respuestatrue = await notificacion(context, "error", "EXACT",
              "Primero debe ingresar el codigo de la bandeja");
          if (respuestatrue == null || respuestatrue) {
            enfocarInputfx(context, f1);
            setState(() {
              listaenvios2 = [];
              codigoMostrar = "";
              mensaje = "";
            });
          }
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

    Widget _validarListado(List<EnvioModel> lista) {
      return _crearListadoinMemoria(lista);
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

    final contenerSwitch2 = Container(
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        valorswitch,
        Expanded(
          child: Container(
            child: isSwitched != true ? Text("En entrega") : Text("En recojo"),
          ),
          flex: 3,
        )
      ]),
    );

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega $numeroRecorrido en sede"),
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
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: contenerSwitch2,
                          margin: const EdgeInsets.only(bottom: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
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
                          margin: const EdgeInsets.only(bottom: 10),
                        ),
                      ),
                      mensaje.length == 0
                          ? Container()
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Container(
                                    child: codigoMostrar.length != 0
                                        ? Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Center(
                                                    child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment: Alignment.center,
                                                  child: Text("$codigoMostrar",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )),
                                                flex: 3,
                                              ),
                                              Expanded(
                                                child: Center(
                                                    child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment: Alignment.center,
                                                  child: Center(
                                                      child: Text("$mensaje")),
                                                )),
                                                flex: 9,
                                              )
                                            ],
                                          )
                                        : Center(
                                            child: Container(
                                            alignment: Alignment.center,
                                            child:
                                                Center(child: Text("$mensaje")),
                                          ))),
                                margin: const EdgeInsets.only(bottom: 10),
                              ),
                            ),
                      Expanded(
                          child: codigoBandeja == ""
                              ? Container()
                              : Container(
                                  child: _validarListado(listaenvios2))),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: botonesinferiores),
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
