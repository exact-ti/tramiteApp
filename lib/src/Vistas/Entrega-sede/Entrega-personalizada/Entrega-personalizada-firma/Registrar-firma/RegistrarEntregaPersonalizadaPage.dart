import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'RegistrarEntregaPersonalizadaController.dart';

class RegistrarEntregapersonalizadoPage extends StatefulWidget {
  final dynamic firma;

  const RegistrarEntregapersonalizadoPage({Key key, this.firma})
      : super(key: key);

  @override
  _RegistrarEntregapersonalizadoPageState createState() =>
      new _RegistrarEntregapersonalizadoPageState(firma);
}

class _RegistrarEntregapersonalizadoPageState
    extends State<RegistrarEntregapersonalizadoPage> {
  dynamic imagenFirma;
  _RegistrarEntregapersonalizadoPageState(this.imagenFirma);
  final _sobreController = TextEditingController();
  RegistrarEntregaPersonalizadaController personalizadacontroller =new RegistrarEntregaPersonalizadaController();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<EnvioModel> listaEnvios = new List();
  FocusNode focusSobre = FocusNode();
  @override
  void initState() {
    listaEnvios = [];
    super.initState();
  }
  void notifierAccion(String mensaje, Color color) {
    final snack = new SnackBar(
      content: new Text(mensaje),
      backgroundColor: color,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    void _validarSobre() async {
      if (_sobreController.text != "") {
        if (listaEnvios.where((envio) => envio.codigoPaquete==_sobreController.text).toList().isEmpty) {
          dynamic respuesta = await personalizadacontroller.guardarEntrega(
              context, imagenFirma, _sobreController.text);
          if (respuesta.containsValue("success")) {
            desenfocarInputfx(context);
            EnvioModel envioModel = new EnvioModel();
            envioModel.codigoPaquete=_sobreController.text;
            envioModel.estado=true;
            setState(() {
              listaEnvios.add(envioModel);
            });
            notifierAccion("Se registró la entrega", StylesThemeData.PRIMARYCOLOR);
          } else {
            setState(() {
              _sobreController.text = "";
            });
            notifierAccion(respuesta["message"], Colors.red);
          }
        } else {
          notifierAccion("Código ya se encuentra validado", Colors.red);
        }
      } else {
        notifierAccion("el código de sobre es obligatorio", Colors.red);
      }
    }

    Future _getDataCameraSobre() async {
      _sobreController.text = await getDataFromCamera(context);
      setState(() {
        _sobreController.text=_sobreController.text;
      });
      _validarSobre();
    }

    Widget campodetextoandIconoFIRMA = Container(
      child:  LimitedBox(
              maxHeight: screenHeightExcludingToolbar(context, dividedBy: 5),
              child: Container(
                  child: RotationTransition(
                      turns: new AlwaysStoppedAnimation(90 / 360),
                      child: Container(
                          child: Image.memory(
                              Base64Decoder().convert(imagenFirma)))))),
    );

    return Scaffold(
        appBar:CustomAppBar(text: "Entrega personalizada"),
        key: scaffoldkey,
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
                      Container(
                          alignment: Alignment.bottomLeft,
                          width: double.infinity,
                          child: Text("Firma"),
                          margin: const EdgeInsets.only(top: 20),
                        ),
                      Container(
                          width: double.infinity,
                          child: campodetextoandIconoFIRMA,
                        ),
                      Container(
                            margin: const EdgeInsets.only(bottom: 5),
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
                ))));
  }
}
