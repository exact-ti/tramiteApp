import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
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
import 'RecepcionRegularController.dart';

class RecepcionInterPage extends StatefulWidget {
  final EnvioInterSedeModel recorridopage;

  const RecepcionInterPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _RecepcionInterPageState createState() =>
      new _RecepcionInterPageState(recorridopage);
}

class _RecepcionInterPageState extends State<RecepcionInterPage> {
  EnvioInterSedeModel recorridoUsuario;
  _RecepcionInterPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  RecepcionInterController principalcontroller = new RecepcionInterController();
  String mensajeconfirmation = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  mostrarenviosiniciales() async {
    listaEnvios = await principalcontroller.listarEnvios(
        context, _bandejaController.text);
    if (listaEnvios != null) {
      if (listaEnvios.length == 0) {
        setState(() {
          listaEnvios = [];
        });
      } else {
        setState(() {
          listaEnvios = listaEnvios;
        });
      }
    } else {
      setState(() {
        listaEnvios = [];
      });
    }
  }

  @override
  void initState() {
    if (recorridoUsuario != null) {
      _bandejaController.text = recorridoUsuario.codigo;
      mostrarenviosiniciales();
    }
    super.initState();
  }

  void sendButton() async {
    if (listaEnvios.length > 0) {
      bool respuestaarray = await confirmarArray(context, "success", "EXACT",
          "Faltan los siguientes elementos a validar", listaEnvios);
      if (respuestaarray == null) {
        Navigator.of(context).pop();
      } else {
        if (respuestaarray) {
          bool respuestatrue = await notificacion(context, "success", "EXACT",
              "Se ha recepcionado los documentos con éxito");
          if (respuestatrue != null) {
            if (respuestatrue) {
              Navigator.of(context).pushNamed('/envio-interutd');
            }
          }
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha completado con la recepción de documentos");
      if (respuestatrue != null) {
        if (respuestatrue) {
          Navigator.of(context).pushNamed('/envio-interutd');
        }
      }
    }
  }

  void _validarSobreText() async {
    if (_bandejaController.text == "" || listaEnvios.length == 0) {
      setState(() {
        _sobreController.text = "";
      });
      popuptoinput(context, f1, "error", "EXACT",
          "Primero debe ingresar el codigo de la valija");
    } else {
      String value = _sobreController.text;
      if (value != "") {
        bool perteneceLista = listaEnvios
            .where((envio) => envio.codigoPaquete == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          dynamic respuestaValidar = await principalcontroller.recogerdocumento(
              context, _bandejaController.text, value, true);
          if (respuestaValidar["status"] == "success") {
            listaEnvios.removeWhere((envio) => envio.codigoPaquete == value);
            if (listaEnvios.length == 0) {
              bool respuestatrue = await notificacion(context, "success",
                  "EXACT", "Se ha recepcionado los documentos con éxito");
                if (respuestatrue) {
                  Navigator.of(context).pushNamed('/envio-interutd');
                }
            }
            setState(() {
              mensajeconfirmation = "El sobre $value fue recepcionado";
              listaEnvios = listaEnvios;
              _sobreController.text = value;
            });
          } else {
            setState(() {
              mensajeconfirmation = "No es posible procesar el código";
              _sobreController.text = value;
            });
          }
          enfocarInputfx(context, f2);
        } else {
          bool respuestaPopUp = await confirmacion(context, "success", "EXACT",
              "El código $value no se encuentra en la lista. ¿Desea continuar?");
          if (respuestaPopUp) {
            dynamic respuestaValidar =
                await principalcontroller.recogerdocumento(
                    context, _bandejaController.text, value, true);
            if (respuestaValidar["status"] != "success") {
              setState(() {
                mensajeconfirmation = "No es posible procesar el código";
                _sobreController.text = value;
              });
              enfocarInputfx(context, f2);
            } else {
              setState(() {
                mensajeconfirmation = "El sobre $value fue recepcionado";
                _sobreController.text = value;
              });
              enfocarInputfx(context, f2);
            }
          } else {
            enfocarInputfx(context, f2);
          }
        }
      } else {
        popuptoinput(context, f1, "error", "EXACT",
            "El ingreso del código de sobre es obligatorio");
      }
    }
  }

  void _validarBandejaText() async {
    String value = _bandejaController.text;
    if (value != "") {
      listaEnvios = await principalcontroller.listarEnvios(context, value);
      if (listaEnvios.isNotEmpty) {
        setState(() {
          mensajeconfirmation = "";
          _bandejaController.text = value;
          listaEnvios = listaEnvios;
        });
        enfocarInputfx(context, f2);
      } else {
        setState(() {
          mensajeconfirmation = "";
          listaEnvios = [];
          _bandejaController.text = value;
        });
        popuptoinput(
            context, f1, "error", "EXACT", "No es posible procesar el código");
      }
    } else {
      popuptoinput(
          context, f1, "error", "EXACT", "El código del lote es obligatorio");
    }
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

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40,bottom: 10),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: Text("Código de valija")),
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
                        hinttext: ""))),
            Container(
                margin: const EdgeInsets.only(top: 20,bottom: 10),
                alignment: Alignment.bottomLeft,
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
                      hinttext: "")),
              margin: const EdgeInsets.only(bottom: 10),
            ),
            mensajeconfirmation.length == 0
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Center(child: Text(mensajeconfirmation))),
            Expanded(
                child: Container(
                    child: ListCod(
              enviosModel: listaEnvios,
            ))),
            listaEnvios.length > 0
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20,top: 10),
                    alignment: Alignment.center,
                    child: CustomButton(
                        onPressed: sendButton,
                        colorParam: StylesThemeData.PRIMARYCOLOR,
                        texto: "Terminar"))
                : Container(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recibir valijas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
