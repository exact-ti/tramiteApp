import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';
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
  RecepcionControllerLote recepcionControllerLote =
      new RecepcionControllerLote();
  final _codValijaController = TextEditingController();
  final _codLoteController = TextEditingController();
  EnvioModel envioModel = new EnvioModel();
  List<EnvioModel> listValijas = new List();
  FocusNode focusCodLote = FocusNode();
  FocusNode focusCodValija = FocusNode();

  @override
  void initState() {
    if (entregaLote != null) {
      _codLoteController.text = entregaLote.paqueteId;
      iniciarlistValijas();
    } else {
      listValijas = [];
    }
    super.initState();
  }

  void iniciarlistValijas() async {
    dynamic dataListEnvios = await recepcionControllerLote
        .listarEnviosLotes(_codLoteController.text);
    setState(() {
      listValijas = envioModel.fromJsonValidar(dataListEnvios["data"]);
    });
  }

  void contieneCodigo(codigo) async {
    bool pertenecia = false;
    for (EnvioModel envio in listValijas) {
      if (envio.codigoPaquete == codigo) {
        pertenecia = true;
      }
    }
    if (pertenecia == true) {
      bool respuesta = await recepcionControllerLote.recogerdocumentoLote(
          context, _codLoteController.text, codigo);
      if (respuesta) {
        listValijas.removeWhere((value) => value.codigoPaquete == codigo);
        if (listValijas.isEmpty) {
          bool respuestatrue = await notificacion(
              context, "success", "EXACT", "Se ha completado la recepción");
          if (respuestatrue) {
            Navigator.of(context).pushNamed('/envio-lote');
          }
          setState(() {
            _codValijaController.text = codigo;
            listValijas = listValijas;
          });
        } else {
          setState(() {
            _codValijaController.text = codigo;
            listValijas = listValijas;
          });
          enfocarInputfx(context, focusCodValija);
        }
      } else {
        setState(() {
          _codValijaController.text = codigo;
        });
        popuptoinput(context, focusCodValija, "error", "EXACT",
            "No es posible procesar el código");
      }
    } else {
      bool respuestaPopUp = await confirmacion(
          context, "success", "EXACT", "¿Desea custodiar el envío $codigo?");
      if (respuestaPopUp) {
        bool respuesta = await recepcionControllerLote.recogerdocumentoLote(
            context, _codLoteController.text, codigo);
        if (respuesta) {
          setState(() {
            _codValijaController.text = codigo;
          });
          popuptoinput(context, focusCodValija, "success", "EXACT",
              "Se registró la valija");
        } else {
          setState(() {
            _codValijaController.text = codigo;
          });
          popuptoinput(context, focusCodValija, "error", "EXACT",
              "No es posible procesar el código");
        }
      } else {
        enfocarInputfx(context, focusCodValija);
      }
    }
  }

  void _validarCodValija(dynamic valueValijaController) async {
    if (_codLoteController.text == "") {
      notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo del lote");
    } else {
      if (_codValijaController.text != "") {
        bool perteneceLista = listValijas
            .where((envio) => envio.codigoPaquete == _codValijaController.text)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          bool respuesta = await recepcionControllerLote.recogerdocumentoLote(
              context, _codLoteController.text, _codValijaController.text);
          if (respuesta) {
            listValijas.removeWhere(
                (value) => value.codigoPaquete == _codValijaController.text);
            if (listValijas.isEmpty) {
              bool respuestaModal = await notificacion(
                  context, "success", "EXACT", "Se ha completado la recepción");
              if (respuestaModal) {
                Navigator.of(context).pushNamed('/envio-lote');
              }
              setState(() {
                listValijas = listValijas;
              });
            } else {
              setState(() {
                listValijas = listValijas;
              });
              enfocarInputfx(context, focusCodValija);
            }
          } else {
            popuptoinput(context, focusCodValija, "error", "EXACT",
                "No es posible procesar el código");
          }
        } else {
          bool respuestaPopUp = await confirmacion(context, "success", "EXACT",
              "¿Desea custodiar el envío ${_codValijaController.text}");
          if (respuestaPopUp) {
            bool respuesta = await recepcionControllerLote.recogerdocumentoLote(
                context, _codLoteController.text, _codValijaController.text);
            if (respuesta) {
              popuptoinput(context, focusCodValija, "success", "EXACT",
                  "Se registró la valija");
            } else {
              popuptoinput(context, focusCodValija, "error", "EXACT",
                  "No es posible procesar el código");
            }
          } else {
            enfocarInputfx(context, focusCodValija);
          }
        }
      } else {
        popuptoinput(context, focusCodValija, "error", "EXACT",
            "El código de valija es obligatorio");
      }
    }
  }

  void _listarValijasByCodLote(dynamic valueController) async {
    if (_codLoteController.text != "") {
      dynamic respuesta = await recepcionControllerLote
          .listarEnviosLotes(_codLoteController.text);
      if (respuesta["status"] != "fail") {
        listValijas = envioModel.fromJsonValidar(respuesta["data"]);
        if (listValijas.isNotEmpty) {
          setState(() {
            listValijas = listValijas;
          });
          enfocarInputfx(context, focusCodValija);
        } else {
          setState(() {
            listValijas.clear();
          });
          popuptoinput(context, focusCodLote, "error", "EXACT",
              "No contiene envíos para recepcionar");
        }
      } else {
        setState(() {
          listValijas.clear();
        });
        popuptoinput(
            context, focusCodLote, "error", "EXACT", respuesta["message"]);
      }
    } else {
      setState(() {
        listValijas.clear();
      });
      popuptoinput(context, focusCodLote, "error", "EXACT",
          "El campo del lote no puede estar vacío");
    }
  }

  Future _getDataCameraCodValija() async {
    _codValijaController.text = await getDataFromCamera(context);
    setState(() {
      _codValijaController.text = _codValijaController.text;
    });
    _validarCodValija(_codValijaController.text);
  }

  Future _getDataCameraCodLote() async {
    _codLoteController.text = await getDataFromCamera(context);
    setState(() {
      _codLoteController.text = _codLoteController.text;
    });
    _listarValijasByCodLote(_codLoteController.text);
  }

  void onPressedTerminarButton() async {
    bool respuestaarray = await confirmarArray(context, "success", "EXACT",
        "Te faltan asociar estos documentos", listValijas);
    if (respuestaarray) {
      bool respuestaTrue = await notificacion(context, "success", "EXACT",
          "Se recepcionado correctamente las valijas");
      if (respuestaTrue) {
        Navigator.of(context).pushNamed('/envio-lote');
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Recibir Lotes"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: InputCameraWidget(
                          iconData: Icons.camera_alt,
                          onPressed: _getDataCameraCodLote,
                          inputParam: InputWidget(
                            iconPrefix: IconsData.ICON_SOBRE,
                            controller: _codLoteController,
                            focusInput: focusCodLote,
                            hinttext: "Código de lote",
                            methodOnPressed: _listarValijasByCodLote,
                          ))),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: InputCameraWidget(
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraCodValija,
                        inputParam: InputWidget(
                          iconPrefix: IconsData.ICON_SOBRE,
                          controller: _codValijaController,
                          focusInput: focusCodValija,
                          hinttext: "Código de valija",
                          methodOnPressed: _validarCodValija,
                        )),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: listValijas.length,
                          itemBuilder: (context, i) => ItemWidget(
                              iconPrimary: FontAwesomeIcons.qrcode,
                              iconSend: listValijas[i].estado
                                  ? IconsData.ICON_ENVIO_CONFIRMADO
                                  : null,
                              itemIndice: i,
                              methodAction: null,
                              colorItem: i % 2 == 0
                                  ? StylesThemeData.ITEM_SHADED_COLOR
                                  : StylesThemeData.ITEM_UNSHADED_COLOR,
                              titulo: listValijas[i].codigoPaquete,
                              subtitulo: null,
                              subSecondtitulo: null,
                              styleTitulo: StylesTitleData.STYLE_TITLE,
                              styleSubTitulo: null,
                              styleSubSecondtitulo: null,
                              iconColor: StylesThemeData.ICON_COLOR))),
                  listValijas.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 30, top: 10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: ButtonWidget(
                              onPressed: onPressedTerminarButton,
                              colorParam: StylesThemeData.PRIMARY_COLOR,
                              texto: "Terminar"))
                      : Container(),
                ],
              ),
            ),
            context));
  }
}
