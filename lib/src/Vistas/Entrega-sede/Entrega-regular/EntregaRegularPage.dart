import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Listar-TipoPersonalizada/ListarTipoPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomSwitch.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
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
  List<EnvioModel> listaEnvios = new List();
  EntregaregularController principalcontroller = new EntregaregularController();
  String mensaje = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  bool isSwitched = true;
  String codigoMostrar = '';

  @override
  void initState() {
    super.initState();
  }

  Future _traerdatosescanerSobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarSobreText();
  }

  Future _traerdatosescanerBandeja() async {
    _bandejaController.text = await getDataFromCamera(context);
    setState(() {
      _bandejaController.text = _bandejaController.text;
    });
    _validarBandejaText();
  }

  void registrarDocumento(String documento) async {
    bool pertenecia = listaEnvios
        .where((envio) => envio.codigoPaquete == documento)
        .toList()
        .isNotEmpty;
    if (pertenecia) {
      if (isSwitched) {
        dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
            context,
            recorridoUsuario.id,
            _bandejaController.text,
            documento,
            isSwitched);
        if (respuestaMap.containsValue("success")) {
          dynamic respuestaMap2 = respuestaMap["data"];
          mensaje = respuestaMap2["destino"];
          listaEnvios.removeWhere((value) => value.codigoPaquete == documento);
          codigoMostrar = documento;
        } else {
          codigoMostrar = "";
          mensaje = respuestaMap["message"];
        }
      } else {
        dynamic respuestaMap = await envioController.recogerdocumentoEntrega(
            context,
            recorridoUsuario.id,
            _bandejaController.text,
            documento,
            isSwitched);
        if (respuestaMap["status"] == "success") {
          listaEnvios.removeWhere((value) => value.codigoPaquete == documento);
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
        listaEnvios = listaEnvios;
      });
    } else {
      if (isSwitched) {
        dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
            context,
            recorridoUsuario.id,
            _bandejaController.text,
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
            _bandejaController.text,
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

  void _validarSobreText() async {
    if (_bandejaController.text == "") {
      bool respuestatrue = await notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo de la bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, f1);
        setState(() {
          listaEnvios = [];
          codigoMostrar = "";
          mensaje = "";
        });
      }
    } else {
      String value = _sobreController.text;
      if (value != "") {
        registrarDocumento(value);
      } else {
        bool respuesta = await notificacion(
            context, "error", "EXACT", "Ingrese el codigo de sobre");
        if (respuesta) {
          enfocarInputfx(context, f2);
        }
      }
    }
  }

  void changeSwitch() {
    desenfocarInputfx(context);
    setState(() {
      _sobreController.text = "";
      _bandejaController.text = "";
      listaEnvios.clear();
      isSwitched = isSwitched ? false : true;
      mensaje = "";
      codigoMostrar = "";
    });
  }

  void _validarBandejaText() async {
    String value = _bandejaController.text;
    if (value != "") {
      if (isSwitched) {
        listaEnvios = await principalcontroller.listarEnviosRecojo(
            context, recorridoUsuario.id, value);
        if (listaEnvios == null) {
          notificacion(context, "error", "EXACT",
              "El código no existe en la base de datos");
          setState(() {
            mensaje = "";
            listaEnvios = [];
            _bandejaController.text = value;
          });
          enfocarInputfx(context, f1);
        } else {
          if (listaEnvios.isEmpty) {
            if (isSwitched) {
              bool respuestatrue = await notificacion(context, "error", "EXACT",
                  "No tiene envíos por recoger en el área");
              if (respuestatrue) enfocarInputfx(context, f1);
            } else {
              bool respuestatrue = await notificacion(context, "error", "EXACT",
                  "No tiene envíos por entregar en el área");
              if (respuestatrue) enfocarInputfx(context, f1);
            }
            setState(() {
              mensaje = "";
              listaEnvios = [];
              _bandejaController.text = value;
            });
          } else {
            enfocarInputfx(context, f2);
            setState(() {
              mensaje = "";
              _bandejaController.text = value;
              listaEnvios = listaEnvios;
            });
          }
        }
      } else {
        dynamic respuesta = await principalcontroller.listarEnviosEntrega(
            context, recorridoUsuario.id, value);
        if (respuesta["status"] == "success") {
          listaEnvios = envioModel.fromJsonValidar(respuesta["data"]);
          if (listaEnvios.isEmpty) {
            setState(() {
              listaEnvios = [];
              _bandejaController.text = "";
            });
            bool respuestatrue = await notificacion(context, "error", "EXACT",
                "No tienes envíos para entregar a esta área");
            if (respuestatrue) enfocarInputfx(context, f1);
          } else {
            enfocarInputfx(context, f2);
            setState(() {
              listaEnvios = listaEnvios;
              _bandejaController.text = value;
            });
          }
        } else {
          setState(() {
            listaEnvios = [];
            _bandejaController.text = "";
          });
          bool respuestatrue = await notificacion(
              context, "error", "EXACT", respuesta["message"]);
          if (respuestatrue) enfocarInputfx(context, f1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget botonesinferiores = Row(children: [
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

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: CustomSwitch(
                  onPressed: changeSwitch,
                  switchValue: isSwitched,
                  textEnabled: "En entrega",
                  textDisabled: "En recojo"),
              margin: const EdgeInsets.only(bottom: 10, top: 10),
            ),
            Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(bottom: 5),
                width: double.infinity,
                child: Text("Código de bandeja")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCamera(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerBandeja,
                    inputParam: InputForm(
                      onPressed: _validarBandejaText,
                      controller: _bandejaController,
                      fx: f1,
                      hinttext: "",
                    ))),
            Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(bottom: 5, top: 10),
                width: double.infinity,
                child: Text("Código de sobre")),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: InputCamera(
                  iconData: Icons.camera_alt,
                  onPressed: _traerdatosescanerSobre,
                  inputParam: InputForm(
                    onPressed: _validarSobreText,
                    controller: _sobreController,
                    fx: f2,
                    hinttext: "",
                  )),
              margin: const EdgeInsets.only(bottom: 20),
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
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        alignment: Alignment.center,
                                        child: Text("$codigoMostrar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Center(
                                          child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        alignment: Alignment.center,
                                        child: Center(child: Text("$mensaje")),
                                      )),
                                      flex: 9,
                                    )
                                  ],
                                )
                              : Center(
                                  child: Container(
                                  alignment: Alignment.center,
                                  child: Center(child: Text("$mensaje")),
                                ))),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                  ),
            Expanded(
                child: _bandejaController.text == ""
                    ? Container()
                    : Container(child: ListCod(enviosModel: listaEnvios))),
            Align(
              alignment: Alignment.center,
              child: Container(
                  alignment: Alignment.center,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: botonesinferiores),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega ${recorridoUsuario.id} en sede"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
