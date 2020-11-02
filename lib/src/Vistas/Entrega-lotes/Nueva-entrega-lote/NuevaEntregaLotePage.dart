import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:intl/intl.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'NuevaEntregaLoteController.dart';

class NuevoEntregaLotePage extends StatefulWidget {
  @override
  _NuevoEntregaLotePageState createState() => new _NuevoEntregaLotePageState();
}

class _NuevoEntregaLotePageState extends State<NuevoEntregaLotePage> {
  NuevoEntregaLotePageController nuevoEntregaLotePageController =
      new NuevoEntregaLotePageController();
  final _codValijaController = TextEditingController();
  final _codLoteController = TextEditingController();
  List<TurnoModel> listTurnos = new List();
  List<EnvioModel> listValijas = new List();
  String selectedFc;
  FocusNode focusCodLote = FocusNode();
  FocusNode focusCodValija = FocusNode();
  void initState() {
    super.initState();
    listValijas = [];
    listTurnos = [];
  }

  void onPressedRegistrarButton() {
    if (_codLoteController.text == "") {
      notificacion(
          context, "error", "EXACT", "Debe ingresar el codigo de lote");
    } else {
      if (selectedFc == null) {
        notificacion(context, "error", "EXACT", "Debe seleccionar un turno");
      } else {
        if (listValijas.length == 0) {
          notificacion(
              context, "error", "EXACT", "No hay envíos para registrar");
        } else {
          nuevoEntregaLotePageController.confirmacionDocumentosValidados(
              listValijas,
              context,
              int.parse(selectedFc),
              _codLoteController.text);
        }
      }
    }
  }

  void _listarTurnosByCodValija() async {
    TurnoModel turnoModel = new TurnoModel();
    dynamic turnosmap = await nuevoEntregaLotePageController.listarturnos(
        context, _codLoteController.text);
    if (turnosmap["status"] == "success") {
      listTurnos = turnoModel.fromJson(turnosmap["data"]);
    } else {
      listTurnos = [];
    }
    selectedFc = null;
    if (listTurnos.length != 0) {
      setState(() {
        listTurnos = listTurnos;
      });
      enfocarInputfx(context, focusCodValija);
    } else {
      setState(() {
        listTurnos = [];
        _codLoteController.text = "";
      });
      popuptoinput(
          context, focusCodLote, "error", "EXACT", turnosmap["message"]);
    }
  }

  void _validarCodValija() async {
    if (_codLoteController.text == "") {
      popuptoinput(context, focusCodLote, "error", "EXACT",
          "Primero debe ingresar el codigo del lote");
    } else {
      if (_codValijaController.text == "") {
        popuptoinput(context, focusCodValija, "error", "EXACT",
            "el código de valija es obligatorio");
      } else {
        EnvioModel envioModel = await nuevoEntregaLotePageController
            .validarCodigo(_codValijaController.text, context, listValijas);
        if (envioModel != null) {
          if (listValijas.length == 0) {
            setState(() {
              _codValijaController.text = "";
              listValijas.add(envioModel);
            });
          } else {
            if (listValijas
                .where(
                    (envio) => envio.codigoPaquete == _codValijaController.text)
                .toList()
                .isEmpty) {
              setState(() {
                listValijas.add(envioModel);
              });
            } else {
              popuptoinput(context, focusCodValija, "error", "EXACT",
                  "La valija ya fue agregada al lote");
            }
          }
        } else {
          popuptoinput(context, focusCodValija, "error", "EXACT",
              "No es posible procesar el código");
        }
      }
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
    _listarTurnosByCodValija();
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearCombo(String codigo, List<TurnoModel> listTurnos) {
      return new Container(
          decoration: BoxDecoration(
              color: StylesThemeData.ITEMTURNOCOLOR,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  width: 3,
                  color: StylesThemeData.ITEMTURNOCOLOR,
                  style: BorderStyle.solid)),
          child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                  underline: Container(
                    height: 2,
                    color: StylesThemeData.ITEMTURNOCOLOR,
                  ),
                  isExpanded: true,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  hint: new Align(
                      alignment: Alignment.center,
                      child: listTurnos.length != 0
                          ? Text("Escoge un turno")
                          : Text("- - - - - - - - - - - - -")),
                  onChanged: (newValue) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      selectedFc = newValue;
                    });
                  },
                  value: selectedFc,
                  items: listTurnos
                      .map((fc) => DropdownMenuItem<String>(
                            child: Center(
                              child: fc.id.toString() == selectedFc
                                  ? Container(
                                      child: Text(DateFormat('HH:mm:ss')
                                              .format(fc.horaInicio) +
                                          "-" +
                                          DateFormat('HH:mm:ss')
                                              .format(fc.horaFin)))
                                  : Text(DateFormat('HH:mm:ss')
                                          .format(fc.horaInicio) +
                                      "-" +
                                      DateFormat('HH:mm:ss')
                                          .format(fc.horaFin)),
                            ),
                            value: fc.id.toString(),
                          ))
                      .toList())));
    }

    Widget comboList(String codigo, List<TurnoModel> listTurnos) {
      return Row(children: <Widget>[
        Expanded(
          child: _crearCombo(codigo, listTurnos),
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
      ]);
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega de lotes"),
        drawer: DrawerPage(),
        body: scaffoldbody(Padding(
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
                                onPressed: _listarTurnosByCodValija,
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 5),
                          alignment: Alignment.bottomLeft,
                          width: double.infinity,
                          child: Text("Turno")),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          child:comboList(_codLoteController.text, listTurnos)),
                      Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(top: 10,bottom: 5),
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
                        margin: const EdgeInsets.only(bottom: 30),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(top: 20,bottom: 10),
                        child: ListCod(enviosModel: listValijas),
                      )),
                      listValijas.length != 0
                          ? Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: CustomButton(
                                  onPressed: onPressedRegistrarButton,
                                  colorParam: StylesThemeData.PRIMARYCOLOR,
                                  texto: "Registrar"))
                          : Container(),
                    ],
                  ),
                ), context));
  }
}
