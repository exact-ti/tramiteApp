import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Listar-TipoPersonalizada/ListarTipoPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/SwitchWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';
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
  FocusNode focusBandeja = FocusNode();
  FocusNode focusEnvio = FocusNode();
  bool enRecojo = true;
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
    _validarSobreText(_sobreController.text);
  }

  Future _traerdatosescanerBandeja() async {
    _bandejaController.text = await getDataFromCamera(context);
    setState(() {
      _bandejaController.text = _bandejaController.text;
    });
    _validarBandejaText(_bandejaController.text);
  }

  void registrarDocumento(String documento) async {
    bool pertenecia = listaEnvios
        .where((envio) => envio.codigoPaquete == documento)
        .toList()
        .isNotEmpty;
    if (pertenecia) {
      if (enRecojo) {
        dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
            context,
            recorridoUsuario.id,
            _bandejaController.text,
            documento,
            enRecojo);
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
            enRecojo);
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
      if (enRecojo) {
        dynamic respuestaMap = await envioController.recogerdocumentoRecojo(
            context,
            recorridoUsuario.id,
            _bandejaController.text,
            documento,
            enRecojo);
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
            enRecojo);
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
    enfocarInputfx(context, focusEnvio);
  }

  void _validarSobreText(dynamic valueController) async {
    if (_bandejaController.text == "") {
      bool respuestatrue = await notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo de la bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, focusBandeja);
        setState(() {
          listaEnvios = [];
          codigoMostrar = "";
          mensaje = "";
        });
      }
    } else {
      if (valueController != "") {
        registrarDocumento(valueController);
      } else {
        bool respuesta = await notificacion(
            context, "error", "EXACT", "Ingrese el codigo de sobre");
        if (respuesta) {
          enfocarInputfx(context, focusEnvio);
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
      enRecojo = enRecojo ? false : true;
      mensaje = "";
      codigoMostrar = "";
    });
  }

  void _validarBandejaText(dynamic value) async {
    if (value != "") {
      if (enRecojo) {
        listaEnvios = await principalcontroller.listarEnviosRecojo(
            context, recorridoUsuario.id, value);
        if (listaEnvios == null) {
          bool respuestaNotificacion = await notificacion(context, "error",
              "EXACT", "El código no existe en la base de datos");
          if (respuestaNotificacion) {
            setState(() {
              mensaje = "";
              listaEnvios = [];
            });
            enfocarInputfx(context, focusBandeja);
          }
        } else {
          if (listaEnvios.isEmpty) {
            if (enRecojo) {
              bool respuestatrue = await notificacion(context, "error", "EXACT",
                  "No tiene envíos por recoger en el área");
              if (respuestatrue) enfocarInputfx(context, focusBandeja);
            } else {
              bool respuestatrue = await notificacion(context, "error", "EXACT",
                  "No tiene envíos por entregar en el área");
              if (respuestatrue) enfocarInputfx(context, focusBandeja);
            }
            setState(() {
              mensaje = "";
              listaEnvios = [];
              _bandejaController.text = value;
            });
          } else {
            enfocarInputfx(context, focusEnvio);
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
            if (respuestatrue) enfocarInputfx(context, focusBandeja);
          } else {
            enfocarInputfx(context, focusEnvio);
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
          if (respuestatrue) enfocarInputfx(context, focusBandeja);
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
              child: SwitchWidget(
                  onPressed: changeSwitch,
                  switchValue: enRecojo,
                  textEnabled: "En entrega",
                  textDisabled: "En recojo"),
              margin: const EdgeInsets.only(bottom: 10, top: 10),
            ),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCameraWidget(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerBandeja,
                    inputParam: InputWidget(
                      iconPrefix: IconsData.ICON_SOBRE,
                      methodOnPressed: _validarBandejaText,
                      controller: _bandejaController,
                      focusInput: focusBandeja,
                      hinttext: "Código de bandeja",
                    ))),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: InputCameraWidget(
                  iconData: Icons.camera_alt,
                  onPressed: _traerdatosescanerSobre,
                  inputParam: InputWidget(
                    iconPrefix: IconsData.ICON_SOBRE,
                    methodOnPressed: _validarSobreText,
                    controller: _sobreController,
                    focusInput: focusEnvio,
                    hinttext: "Código de sobre",
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
                                        margin: EdgeInsets.only(right: 20),
                                        alignment: Alignment.center,
                                        child: Text("$codigoMostrar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      )),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Center(
                                          child: Container(
                                        margin: EdgeInsets.only(right: 20),
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: Text("$mensaje",
                                                style:
                                                    TextStyle(fontSize: 14))),
                                      )),
                                      flex: 3,
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
                    : Container(
                        child: ListView.builder(
                            itemCount: listaEnvios.length,
                            itemBuilder: (context, i) => ItemWidget(
                                iconPrimary: FontAwesomeIcons.qrcode,
                                iconSend: listaEnvios[i].estado
                                    ? IconsData.ICON_ENVIO_CONFIRMADO
                                    : null,
                                itemIndice: i,
                                methodAction: null,
                                colorItem: i % 2 == 0
                                    ? StylesThemeData.ITEM_SHADED_COLOR
                                    : StylesThemeData.ITEM_UNSHADED_COLOR,
                                titulo: listaEnvios[i].codigoPaquete,
                                subtitulo: null,
                                subSecondtitulo: null,
                                styleTitulo: StylesTitleData.STYLE_TITLE,
                                styleSubTitulo: null,
                                styleSubSecondtitulo: null,
                                iconColor: StylesThemeData.ICON_COLOR)))),
            Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                alignment: Alignment.center,
                width: double.infinity,
                child: botonesinferiores),
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
