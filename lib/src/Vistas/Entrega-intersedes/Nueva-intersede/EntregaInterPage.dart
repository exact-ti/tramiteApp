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
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'EntregaInterController.dart';

class NuevoIntersedePage extends StatefulWidget {
  @override
  _NuevoIntersedePageState createState() => new _NuevoIntersedePageState();
}

class _NuevoIntersedePageState extends State<NuevoIntersedePage> {
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  EntregaregularController principalcontroller = new EntregaregularController();
  List<EnvioModel> listaEnvios = [];
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  void initState() {
    super.initState();
  }

  void sendPress() async {
    if (_bandejaController.text == "") {
      notificacion(context, "error", "EXACT", "Debe ingresar el codigo de bandeja");
    } else {
      if (listaEnvios.length != 0) {
        _sobreController.text = "";
        if (listaEnvios.where((envio) => !envio.estado).toList().isEmpty) {
          principalcontroller.confirmacionDocumentosValidadosEntrega(
              listaEnvios, context, _bandejaController.text);
          _bandejaController.text;
        } else {
          bool respuestaarray = await confirmarArray(
              context,
              "success",
              "EXACT",
              "Faltan los siguientes elementos a validar:",
              listaEnvios.where((envio) => !envio.estado).toList());
          if (respuestaarray) {
            principalcontroller.confirmacionDocumentosValidadosEntrega(
                listaEnvios.where((envio) => envio.estado).toList(),
                context,
                _bandejaController.text);
          }
        }
      } else {
        notificacion(context, "error", "EXACT", "No hay envíos para registrar");
      }
    }
  }

  void _validarSobreText() async {
    if (_bandejaController.text == "") {
      _sobreController.text = "";
      bool respuestatrue = await notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo de la bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, f1);
      }
    } else {
      String value = _sobreController.text;
      if (value != "") {
        bool perteneceLista = listaEnvios
            .where((envio) => envio.codigoPaquete == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          setState(() {
            listaEnvios.forEach((envio) {
              if (envio.codigoPaquete == value) {
                envio.estado = true;
              }
            });
            _sobreController.text = "";
          });
          enfocarInputfx(context, f2);
        } else {
          EnvioModel enviocontroller = await principalcontroller.validarCodigoEntrega(_bandejaController.text, value, context);
          if (enviocontroller != null) {
            setState(() {
              _sobreController.text = "";
              listaEnvios.add(enviocontroller);
            });
            bool respuestatrue = await notificacion(context, "success", "EXACT", "Envío agregado a la entrega");
            if (respuestatrue) {
              enfocarInputfx(context, f2);
            }
          } else {
            setState(() {
              _sobreController.text = value;
            });
            bool respuestatrue = await notificacion(context, "error", "EXACT", "No es posible procesar el código");
            if (respuestatrue) {
              enfocarInputfx(context, f2);
            }
          }
        }
      } else {
        bool respuestatrue = await notificacion(
            context, "error", "EXACT", "El campo del sobre no puede ser vacío");
        if (respuestatrue) {
          enfocarInputfx(context, f2);
        }
      }
    }
  }

  void validarListaByBandeja() async {
    String codigo = _bandejaController.text;
    if (codigo != "") {
      listaEnvios = await principalcontroller.listarEnviosEntrega(context, codigo);
      if (listaEnvios.isNotEmpty) {
        setState(() {
          listaEnvios = listaEnvios;
          _sobreController.text = "";
          _bandejaController.text = codigo;
        });
        enfocarInputfx(context, f2);
      } else {
        bool respuestatrue = await notificacion(
            context, "error", "EXACT", "No es posible procesar el código");
        setState(() {
          _sobreController.text = "";
          listaEnvios = [];
          _bandejaController.text = codigo;
        });
        if (respuestatrue) {
          enfocarInputfx(context, f1);
        }
      }
    } else {
      bool respuestatrue = await notificacion(
          context, "error", "EXACT", "Debe ingresar el código de bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, f1);
      }
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
    validarListaByBandeja();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 40,bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text("Código de valija")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCamera(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerBandeja,
                    inputParam: InputForm(
                        onPressed: validarListaByBandeja,
                        controller: _bandejaController,
                        fx: f1,
                        hinttext: ""))),
            Container(
                margin: EdgeInsets.only(top: 20,bottom: 10),
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
              margin: const EdgeInsets.only(bottom: 30),
            ),
            Expanded(child: ListCod(enviosModel: listaEnvios)),
            listaEnvios.where((envio) => envio.estado).toList().isNotEmpty
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10,top: 10),
                    child: CustomButton(
                        onPressed: sendPress,
                        colorParam: StylesThemeData.PRIMARYCOLOR,
                        texto: "Registrar"))
                : Container(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Nueva entrega"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
