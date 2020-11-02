import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'EntregaPersonalizadaController.dart';

class EntregapersonalizadoPageDNI extends StatefulWidget {
  @override
  _EntregapersonalizadoPageDNIState createState() =>
      new _EntregapersonalizadoPageDNIState();
}

class _EntregapersonalizadoPageDNIState
    extends State<EntregapersonalizadoPageDNI> {
  final _sobreController = TextEditingController();
  final _dniController = TextEditingController();
  EntregaPersonalizadaController personalizadacontroller = new EntregaPersonalizadaController();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<EnvioModel> listaEnvios = new List();
  FocusNode focusDNI = FocusNode();
  FocusNode focusSobre = FocusNode();
  @override
  void initState() {
    listaEnvios = [];
    super.initState();
  }

  void notifierAccion(String mensaje, String color) {
    final snack = new SnackBar(
      content: new Text("Se registró el envío"),
      backgroundColor: StylesThemeData.PRIMARYCOLOR,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  void _validarSobre() async {
    if (_dniController.text == "") {
      _sobreController.text = "";
      notificacion(context, "error", "EXACT", "Primero debe ingresar el DNI");
    } else {
      if (_sobreController.text != "") {
        if (listaEnvios.where((envio) => envio.codigoPaquete==_sobreController.text).toList().isEmpty) {
          bool respuesta = await personalizadacontroller.guardarEntrega(context, _dniController.text, _sobreController.text);
          if (respuesta) {
            desenfocarInputfx(context);
            EnvioModel envioModel = new EnvioModel();
            envioModel.codigoPaquete=_sobreController.text;
            envioModel.estado=true;
            setState(() {
              _sobreController.text = "";
              listaEnvios.add(envioModel);
            });
            notifierAccion(
                "El envío ${_sobreController.text} fue entregado correctamente", "38CE00");
          } else {
            popuptoinput(context, focusSobre, "error", "EXACT",
                "El código no existe, por favor intente nuevamente");
          }
        } else {
          popuptoinput(context, focusSobre, "error", "EXACT",
              "Código ya se encuentra validado");
        }
      } else {
        popuptoinput(context, focusSobre, "error", "EXACT",
            "El código de sobre es obligatorio");
      }
    }
  }

  void _validarDNI() {
    if (_dniController.text == "") {
      popuptoinput(
          context, focusDNI, "error", "EXACT", "El DNI es obligatorio");
    } else {
      enfocarInputfx(context, focusSobre);
    }
  }

  Future _getDataCameraSobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text=_sobreController.text;
    });
    _validarSobre();
  }

  Future _getDataCameraDNI() async {
    _dniController.text = await getDataFromCamera(context);
    setState(() {
      _dniController.text = _dniController.text;
    });
    _validarDNI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        key: scaffoldkey,
        body: scaffoldbody(
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    child: Text("Código"),
                    margin: EdgeInsets.only(top: 20,bottom: 5),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: InputCamera(
                          iconData: Icons.camera_alt,
                          onPressed: _getDataCameraDNI,
                          inputParam: InputForm(
                            controller: _dniController,
                            fx: focusDNI,
                            hinttext: "",
                            onPressed: _validarDNI,
                          ))),
                  Container(
                      margin: EdgeInsets.only(top: 10,bottom: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text("Código de sobre")),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: InputCamera(
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraSobre,
                        inputParam: InputForm(
                          controller: _sobreController,
                          fx: focusSobre,
                          hinttext: "",
                          onPressed: _validarSobre,
                        )),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ListCod(enviosModel: listaEnvios)),
                  ),
                ],
              ),
            ),
            context));
  }
}
