import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'NuevaEntregaExternaController.dart';

class NuevoEntregaExternaPage extends StatefulWidget {
  @override
  _NuevoEntregaExternaPageState createState() =>
      new _NuevoEntregaExternaPageState();
}

class _NuevoEntregaExternaPageState extends State<NuevoEntregaExternaPage> {
  final _codigoEnvioController = TextEditingController();
  final _codigoValijaController = TextEditingController();
  FocusNode focusValija = FocusNode();
  FocusNode focusEnvio = FocusNode();
  List<EnvioModel> listaEnvios = [];
  NuevoEntregaExternaController principalcontroller = new NuevoEntregaExternaController();

  void initState() {
    super.initState();
  }

  void onPressRegistrarButton() async {
    if (listaEnvios.where((envio) => envio.estado).toList().isEmpty) {
      popuptoinput(context, focusEnvio, "error", "EXACT","No hay ningún envío validado");
    } else {
      List<EnvioModel> listaEnviosNovalidados = listaEnvios.where((envio) => !envio.estado).toList();
      if (listaEnviosNovalidados.isEmpty) {
        principalcontroller.confirmacionDocumentosValidadosEntrega(
            listaEnvios, context, _codigoValijaController.text);
      } else {
        bool respuestaarray = await confirmarArray(context, "success", "EXACT", "Te faltan asociar estos documentos",listaEnviosNovalidados);
        if (respuestaarray) {
          principalcontroller.confirmacionDocumentosValidadosEntrega(
              listaEnvios.where((envio) => envio.estado).toList(), context, _codigoValijaController.text);
        }
      }
    }
  }

  void _validarCodEnvio() async {
    if (_codigoValijaController.text == "") {
      popuptoinput(context, focusValija, "error", "EXACT",
          "Primero debe ingresar el codigo de la valija");
    } else {
      if (_codigoEnvioController.text != "") {
        bool perteneceLista = listaEnvios
            .where(
                (envio) => envio.codigoPaquete == _codigoEnvioController.text)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          setState(() {
            _codigoEnvioController.clear();
            listaEnvios.forEach((envio) {
              envio.estado = true;
            });
          });
          enfocarInputfx(context, focusEnvio);
        } else {
          EnvioModel enviocontroller =
              await principalcontroller.validarCodigoEntrega(
                  _codigoValijaController.text,
                  _codigoEnvioController.text,
                  context);
          if (enviocontroller != null) {
            setState(() {
              listaEnvios.add(enviocontroller);
            });
            popuptoinput(context, focusEnvio, "success", "EXACT",
                "Envío agregado a la entrega");
          } else {
            popuptoinput(context, focusEnvio, "error", "EXACT",
                "No es posible procesar el código");
          }
        }
      } else {
        popuptoinput(context, focusEnvio, "error", "EXACT",
            "El campo del sobre no puede ser vacío");
      }
    }
  }

  void _listarCodEnviosByValija() async {
    if (_codigoValijaController.text != "") {
      EnvioModel envioModel = new EnvioModel();
      dynamic respuestalist = await principalcontroller.listarEnviosEntrega(
          context, _codigoValijaController.text);
      if (respuestalist["status"] == "success") {
        dynamic dataListEnvios = respuestalist["data"];
        listaEnvios = envioModel.fromJsonValidar(dataListEnvios);
        if (listaEnvios.isNotEmpty) {
          setState(() {
            listaEnvios = listaEnvios;
            _codigoEnvioController.clear();
          });
          enfocarInputfx(context, focusEnvio);
        } else {
          setState(() {
            _codigoEnvioController.clear();
            listaEnvios.clear();
            _codigoValijaController.clear();
          });
          popuptoinput(context, focusValija, "error", "EXACT",
              "No cuenta con envíos asociados");
        }
      } else {
        popuptoinput(
            context, focusValija, "error", "EXACT", respuestalist["message"]);
        setState(() {
          _codigoEnvioController.clear();
          listaEnvios.clear();
          _codigoValijaController.clear();
        });
      }
    } else {
      setState(() {
        listaEnvios.clear();
        _codigoEnvioController.clear();
      });
      popuptoinput(
          context, focusValija, "error", "EXACT", "La bandeja es obligatoria");
    }
  }

  Future _getDataCameraCodEnvio() async {
    _codigoEnvioController.text = await getDataFromCamera(context);
    setState(() {
      _codigoEnvioController.text = _codigoEnvioController.text;
    });
    _validarCodEnvio();
  }

  Future _getDataCameraCodValija() async {
    _codigoValijaController.text = await getDataFromCamera(context);
    setState(() {
      _codigoValijaController.text = _codigoValijaController.text;
    });
    _listarCodEnviosByValija();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Entregas externas"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 20,bottom: 5),
                      alignment: Alignment.bottomLeft,
                      width: double.infinity,
                      child: Text("Código de valija")),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: InputCamera(
                        inputParam: InputForm(
                            controller: _codigoValijaController,
                            fx: focusValija,
                            hinttext: "",
                            onPressed: _listarCodEnviosByValija),
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraCodValija,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10,bottom: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text("Código de envío")),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: InputCamera(
                        inputParam: InputForm(
                            controller: _codigoEnvioController,
                            fx: focusEnvio,
                            hinttext: "",
                            onPressed: _validarCodEnvio),
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraCodEnvio),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(
                    child: Container(child: ListCod(enviosModel: listaEnvios)),
                  ),
                  listaEnvios.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: CustomButton(
                              onPressed: onPressRegistrarButton,
                              colorParam: StylesThemeData.PRIMARYCOLOR,
                              texto: "Registrar"))
                      : Container(),
                ],
              ),
            ),
            context));
  }
}
