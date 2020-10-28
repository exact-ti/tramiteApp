import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemConsult.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'ConsultaEnvioController.dart';

class ConsultaEnvioPage extends StatefulWidget {
  @override
  _ConsultaEnvioPageState createState() => new _ConsultaEnvioPageState();
}

class _ConsultaEnvioPageState extends State<ConsultaEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  ConsultaEnvioController principalcontroller = new ConsultaEnvioController();
  List<EnvioModel> listaEnvios = new List();
  FocusNode f1paquete = FocusNode();
  FocusNode f2remitente = FocusNode();
  FocusNode f3destinatario = FocusNode();
  bool activo = false;
  bool button = false;

  void initState() {
    super.initState();
  }

  void _validarPaqueteText() async {
    enfocarInputfx(context, f2remitente);
  }

  void _validarRemitenteText() async {
    enfocarInputfx(context, f3destinatario);
  }

  void _validarDestinatarioText() {}

  Future _traerdatosescanerPaquete() async {
    _paqueteController.text = await getDataFromCamera(context);
    setState(() {
      _paqueteController.text = _paqueteController.text;
    });
    enfocarInputfx(context, f2remitente);
  }

  void listarEnvios(String paquete, String remitente, String destinatario,
      bool opcion) async {
    this.listaEnvios = await principalcontroller.listarEnvios(
        context, paquete, remitente, destinatario, opcion);
    if (this.listaEnvios.isNotEmpty) {
      setState(() {
        this.listaEnvios = this.listaEnvios;
      });
    } else {
      this.listaEnvios.clear();
      setState(() {
        this.listaEnvios = this.listaEnvios;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sendButton = Container(
        margin: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              desenfocarInputfx(context);
              if (_paqueteController.text == "" &&
                  _remitenteController.text == "" &&
                  _destinatarioController.text == "") {
                notificacion(context, "error", "EXACT",
                    "Se debe llenar al menos un campo");
                setState(() {
                  button = false;
                  listaEnvios = [];
                });
              } else {
                setState(() {
                  button = true;
                });
                listarEnvios(_paqueteController.text, _remitenteController.text,
                    _destinatarioController.text, activo);
              }
            },
            color: StylesThemeData.PRIMARYCOLOR,
            child: Text('Buscar', style: TextStyle(color: Colors.white)),
          ),
        ));

    Widget mostrarText(bool opcion) {
      return Container(
          child: new GestureDetector(
        onTap: () {
          if (opcion) {
            listarEnvios(_paqueteController.text, _remitenteController.text,
                _destinatarioController.text, false);
            setState(() {
              activo = false;
            });
          } else {
            listarEnvios(_paqueteController.text, _remitenteController.text,
                _destinatarioController.text, true);
            setState(() {
              activo = true;
            });
          }
        },
        child: opcion == false
            ? Text(
                "Mostrar inactivos",
                style: TextStyle(color: Colors.grey),
              )
            : Text(
                "Mostrar activos",
                style: TextStyle(color: Colors.blue),
              ),
      ));
    }

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40, bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text("Código de paquete")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCamera(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerPaquete,
                    inputParam: InputForm(
                        onPressed: _validarPaqueteText,
                        controller: _paqueteController,
                        fx: f1paquete,
                        align: null,
                        hinttext: ""))),
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text("De")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Row(children: <Widget>[
                  Expanded(
                    child: InputForm(
                        onPressed: _validarRemitenteText,
                        controller: _remitenteController,
                        fx: f2remitente,
                        align: null,
                        hinttext: ""),
                    flex: 5,
                  ),
                  Expanded(
                    child: Opacity(
                        opacity: 0.0,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.camera_alt),
                        )),
                  ),
                ])),
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text("Para")),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Row(children: <Widget>[
                Expanded(
                  child: InputForm(
                      onPressed: _validarDestinatarioText,
                      controller: _destinatarioController,
                      fx: f3destinatario,
                      align: null,
                      hinttext: ""),
                  flex: 5,
                ),
                Expanded(
                  child: Opacity(
                      opacity: 0.0,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Icon(Icons.camera_alt),
                      )),
                ),
              ]),
              margin: const EdgeInsets.only(bottom: 20),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Row(children: <Widget>[
                Expanded(
                  child: sendButton,
                  flex: 5,
                ),
                Expanded(
                  child: Opacity(
                      opacity: 0.0,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Icon(Icons.camera_alt),
                      )),
                ),
              ]),
            ),
            button == true
                ? Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 10),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: mostrarText(activo),
                  )
                : Container(),
            Expanded(child: ItemsConsult(enviosModel: this.listaEnvios)),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Consultas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
