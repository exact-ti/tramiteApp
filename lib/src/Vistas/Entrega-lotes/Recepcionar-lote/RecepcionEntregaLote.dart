import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
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
  RecepcionControllerLote recepcionControllerLote = new RecepcionControllerLote();
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
    dynamic dataListEnvios = await recepcionControllerLote.listarEnviosLotes(_codLoteController.text);
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

  void _validarCodValija() async {
    if (_codLoteController.text == "") {
      notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo del lote");
    } else {
      if (_codValijaController.text != "") {
        bool perteneceLista = listValijas.where((envio) => envio.codigoPaquete==_codValijaController.text).toList().isNotEmpty;
        if (perteneceLista) {
          bool respuesta = await recepcionControllerLote.recogerdocumentoLote(context, _codLoteController.text,_codValijaController.text);
          if (respuesta) {
            listValijas.removeWhere((value) => value.codigoPaquete == _codValijaController.text);
            if (listValijas.isEmpty) {
              bool respuestaModal = await notificacion(context, "success", "EXACT", "Se ha completado la recepción");
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

  void _listarValijasByCodLote() async {
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
    _validarCodValija();
  }

  Future _getDataCameraCodLote() async {
    _codLoteController.text = await getDataFromCamera(context);
    setState(() {
      _codLoteController.text = _codLoteController.text;
    });
    _listarValijasByCodLote();
  }

  void onPressedTerminarButton() async {
    bool respuestaarray = await confirmarArray(context, "success", "EXACT",
        "Te faltan asociar estos documentos", listValijas);
    if (respuestaarray == null) {
      Navigator.of(context).pop();
    } else {
      if (respuestaarray) {
        bool respuestaTrue = await notificacion(context, "success", "EXACT",
            "Se recepcionado correctamente las valijas");
        if (respuestaTrue = !null) {
          if (respuestaTrue) {
            Navigator.of(context).pushNamed('/envio-lote');
          }
        }
      } else {
        Navigator.of(context).pop();
      }
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
                      margin: const EdgeInsets.only(top: 20,bottom: 5),
                      alignment: Alignment.bottomLeft,
                      width: double.infinity,
                      child: Text("Código de lote")),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: InputCamera(
                          iconData: Icons.camera_alt,
                          onPressed: _getDataCameraCodLote,
                          inputParam: InputForm(
                            controller: _codLoteController,
                            fx: focusCodLote,
                            hinttext: "",
                            onPressed: _listarValijasByCodLote,
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 10,bottom: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text("Código de valija")),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: InputCamera(
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraCodValija,
                        inputParam: InputForm(
                          controller: _codValijaController,
                          fx: focusCodValija,
                          hinttext: "",
                          onPressed: _validarCodValija,
                        )),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(child: ListCod(enviosModel: listValijas)),
                  listValijas.isNotEmpty
                      ? Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: CustomButton(
                              onPressed: onPressedTerminarButton,
                              colorParam: StylesThemeData.PRIMARYCOLOR,
                              texto: "Terminar"))
                      : Container(),
                ],
              ),
            ),
            context));
  }
}
