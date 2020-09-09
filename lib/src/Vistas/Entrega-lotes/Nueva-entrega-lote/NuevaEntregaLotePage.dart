import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tramiteapp/src/Vistas/layout/top-bar/topBarPage.dart';

import 'NuevaEntregaLoteController.dart';

class NuevoEntregaLotePage extends StatefulWidget {
  @override
  _NuevoEntregaLotePageState createState() => new _NuevoEntregaLotePageState();
}

class _NuevoEntregaLotePageState extends State<NuevoEntregaLotePage> {
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<TurnoModel> listaTurnos = new List();
  List<EnvioModel> listaEnviosVacios = new List();
  NuevoEntregaLotePageController principalcontroller =
      new NuevoEntregaLotePageController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  int cantidadPendientes = 0;
  int cantidadInicial = 0;
  String selectedFc;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  bool inicio = true;
  var colorletra = const Color(0xFFACADAD);
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    super.initState();
    listaEnviosVacios = [];
    listaTurnos = [];
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              if (_bandejaController.text == "") {
                notificacion(context, "error", "EXACT",
                    "Debe ingresar el codigo de lote");
              } else {
                if (selectedFc == null) {
                  notificacion(
                      context, "error", "EXACT", "Debe seleccionar un turno");
                } else {
                  if (listaEnviosVacios.length == 0) {
                    notificacion(context, "error", "EXACT",
                        "No hay envíos para registrar");
                  } else {
                    principalcontroller.confirmacionDocumentosValidados(
                        listaEnviosVacios,
                        context,
                        int.parse(selectedFc),
                        _bandejaController.text);
                  }
                }
              }
            },
            color: Color(0xFF2C6983),
            child: Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));

    void _validarBandejaText(String value) async {
      desenfocarInputfx(context);
      TurnoModel turnoModel = new TurnoModel();
      dynamic turnosmap =
          await principalcontroller.listarturnos(context, value);
      if (turnosmap["status"] == "success") {
        listaTurnos = turnoModel.fromJson(turnosmap["data"]);
      } else {
        listaTurnos = [];
      }
      selectedFc = null;
      if (listaTurnos.length != 0) {
        setState(() {
          listaTurnos = listaTurnos;
          _bandejaController.text = value;
        });
        enfocarInputfx(context, f2);
      } else {
        setState(() {
          listaTurnos = [];
          _bandejaController.text = value;
        });
        popuptoinput(context, f1, "error", "EXACT", turnosmap["message"]);
      }
    }

    bool validarContiene(List<EnvioModel> lista, EnvioModel envio) {
      bool boleano = false;
      for (EnvioModel en in lista) {
        if (en.id == envio.id) {
          boleano = true;
        }
      }
      return boleano;
    }

    void _validarSobreText(String value) async {
      desenfocarInputfx(context);
      if (value == "") {
        popuptoinput(context, f2, "error", "EXACT",
            "el código de valija es obligatorio");
      } else {
        EnvioModel envioModel = await principalcontroller.validarCodigo(
            value, context, listaEnviosVacios);
        setState(() {
          _sobreController.text = value;
        });
        if (envioModel != null) {
          if (listaEnviosVacios.length == 0) {
            listaEnviosVacios.add(envioModel);
            setState(() {
              _sobreController.text = "";
              listaEnviosVacios = listaEnviosVacios;
            });
          } else {
            if (!validarContiene(listaEnviosVacios, envioModel)) {
              listaEnviosVacios.add(envioModel);
              setState(() {
                listaEnviosVacios = listaEnviosVacios;
              });
            } else {
              popuptoinput(context, f2, "error", "EXACT",
                  "La valija ya fue agregada al lote");
            }
          }
        } else {
          popuptoinput(context, f2, "error", "EXACT",
              "No es posible procesar el código");
        }
      }
    }

    final textBandeja = Container(
      child: Text("Código de lote"),
    );

    final textTurno = Container(
      child: Text("Turno"),
    );

    final textSobre = Container(
      child: Text("Código de valija"),
    );

    Widget crearItem(EnvioModel envio, int i) {
      String codigopaquete = envio.codigoPaquete;
      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            title: Text("$codigopaquete"),
            leading: FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
            trailing: Icon(
              Icons.check,
              color: Color(0xffC7C7C7),
            ),
          ));
    }

    Future _traerdatosescanerSobre() async {
      qrbarra = await getDataFromCamera();
      if (_bandejaController.text == "") {
        _sobreController.text = "";
        popuptoinput(context, f1, "error", "EXACT",
            "Primero debe ingresar el codigo del lote");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra = await getDataFromCamera();
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      _validarBandejaText(qrbarra);
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f1,
      controller: _bandejaController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        _validarBandejaText(value);
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
      ),
    );

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      focusNode: f2,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (_bandejaController.text == "") {
          _sobreController.text = "";
          popuptoinput(context, f1, "error", "EXACT",
              "Primero debe ingresar el codigo del lote");
        } else {
          _validarSobreText(value);
        }
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
      ),
    );

    Widget _crearListadoAgregar(List<EnvioModel> lista) {
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i], 1));
    }

    Widget _crearCombo(String codigo, List<TurnoModel> listaTurnos) {
      return new Container(
          decoration: BoxDecoration(
              color: Color(0xFFEAEFF2),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  width: 3,
                  color: Color(0xFFEAEFF2),
                  style: BorderStyle.solid)),
          child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                  underline: Container(
                    height: 2,
                    color: Color(0xFFEAEFF2),
                  ),
                  isExpanded: true,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  hint: new Align(
                      alignment: Alignment.center,
                      child: listaTurnos.length != 0
                          ? Text("Escoge un turno")
                          : Text("- - - - - - - - - - - - -")),
                  onChanged: (newValue) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      selectedFc = newValue;
                    });
                  },
                  value: selectedFc,
                  items: listaTurnos
                      .map((fc) => DropdownMenuItem<String>(
                            child: Center(
                              child: fc.id.toString() == selectedFc
                                  ? Container(
                                      /* decoration: BoxDecoration(
                                            color: Color(0xFFEAEFF2),
                                          ),*/
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

    Widget comboList(String codigo, List<TurnoModel> listaTurnos) {
      return Row(children: <Widget>[
        Expanded(
          child: _crearCombo(codigo, listaTurnos),
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

    final campodetextoandIconoSobre = Row(children: <Widget>[
      Expanded(
        child: sobre,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerSobre),
        ),
      ),
    ]);

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: bandeja,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerBandeja),
        ),
      ),
    ]);

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega de lotes"),
        drawer: crearMenu(context),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: textBandeja),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoBandeja),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: textTurno),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: comboList(
                                _bandejaController.text, listaTurnos)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            //width: double.infinity,
                            child: textSobre),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoSobre,
                          margin: const EdgeInsets.only(bottom: 30),
                        ),
                      ),
                      Expanded(
                          child:Container(
                                  child:
                                      _crearListadoAgregar(listaEnviosVacios))),
                      listaEnviosVacios.length!=0? Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 5),
                            width: double.infinity,
                            child: sendButton),
                      ):Container(),
                    ],
                  ),
                ))));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
}
