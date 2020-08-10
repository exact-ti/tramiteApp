import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';
import 'package:intl/intl.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'HistoricoController.dart';

class HistoricoPage extends StatefulWidget {
  @override
  _HistoricoPageState createState() => new _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  TextEditingController _finController = TextEditingController();
  TextEditingController _inicioController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  List<EnvioModel> listaEnviosEntrada = new List();
  List<EnvioModel> listaEnviosSalida = new List();
  HistoricoController principalcontroller = new HistoricoController();
  List<String> listaCodigosValidados = new List();
  FocusNode _focusNode;
  List<bool> isSelected;
  int indexSwitch = 0;
  FocusNode f1inicio = FocusNode();
  FocusNode f2fin = FocusNode();
  bool pressButton = false;
  void initState() {
    isSelected = [true, false];
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _inicioController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void listarEnvios() async {
      _navigationService.showModal();
      this.listaEnviosEntrada =
          await principalcontroller.listarHistoricosController(
              _inicioController.text, _finController.text, 0);
      this.listaEnviosSalida =
          await principalcontroller.listarHistoricosController(
              _inicioController.text, _finController.text, 1);
      this.pressButton = true;
      _navigationService.goBack();
    }

    pressConsulta() {
      if (_inicioController.text != "" && _finController.text != "") {
        DateTime finicio =
            new DateFormat("dd/MM/yyyy").parse(_inicioController.text);
        DateTime ffin = new DateFormat("dd/MM/yyyy").parse(_finController.text);
        var difference = ffin.difference(finicio).inDays;
        if (difference >= 0) {
          listarEnvios();
        } else {
          notificacion(context, "error", "EXACT",
              "La fecha inicial no debe ser mayor a la final");
          setState(() {
            this.pressButton = false;
          });
        }
      } else {
        notificacion(context, "error", "EXACT", "Se debe completar los datos");
        setState(() {
          this.pressButton = false;
        });
      }
    }

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
              pressConsulta();
            },
            color: Color(0xFF2C6983),
            child: Text('Buscar', style: TextStyle(color: Colors.white)),
          ),
        ));

    final textInicio = Container(
      child: Text("Desde"),
    );

    final textFin = Container(
      child: Text("Hasta"),
    );

    Widget crearItem(EnvioModel envio) {
      return Container(
          decoration: myBoxDecoration(colorletra),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text('De',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(envio.remitente,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text('para',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(envio.destinatario,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: new GestureDetector(
                              onTap: () {
                                trackingPopUp(context, envio.id);
                              },
                              child: Text(envio.codigoPaquete,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)),
                            )),
                        flex: 3,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                              "En custodia en UTD " + envio.codigoUbicacion,
                              style: TextStyle(color: Colors.black)),
                        ),
                        flex: 6,
                      ),
                    ],
                  )),
            ],
          ));
    }

    var fechainicio = InkWell(
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
              helpText: "Seleccionar fecha",
              context: context,
              locale: const Locale("es", "ES"),
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (date != null) {
            DateTime fecha =
                new DateFormat("yyyy-MM-dd").parse(date.toIso8601String());
            String fechaString = DateFormat('yyyy-MM-dd').format(fecha);
            String dateFormate =
                DateFormat("dd-MM-yyyy").format(DateTime.parse(fechaString));
            _inicioController.text = dateFormate.replaceAll(RegExp('-'), '/');
          }
        },
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          autofocus: false,
          focusNode: f1inicio,
          controller: _inicioController,
          textInputAction: TextInputAction.next,
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
        ));

    var fechafin = InkWell(
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
              helpText: "Seleccionar fecha",
              context: context,
              locale: const Locale("es", "ES"),
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (date != null) {
            DateTime fecha =
                new DateFormat("yyyy-MM-dd").parse(date.toIso8601String());
            String fechaString = DateFormat('yyyy-MM-dd').format(fecha);
            String dateFormate =
                DateFormat("dd-MM-yyyy").format(DateTime.parse(fechaString));
            _finController.text = dateFormate.replaceAll(RegExp('-'), '/');
          }
        },
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          enabled: false,
          focusNode: f2fin,
          controller: _finController,
          textInputAction: TextInputAction.next,
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
        ));

    Widget _crearListadoAgregar(int tab) {
      List<EnvioModel> listaEnvios = new List();
      if (tab == 0) {
        listaEnvios = listaEnviosSalida;
      } else {
        listaEnvios = listaEnviosEntrada;
      }
      if (listaEnvios.length == 0) {
        return Container(
          decoration: myBigBoxDecoration(colorletra),
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          alignment: Alignment.center,
          child: Center(child: sinResultados("No se encontraron resultados")),
        );
      } else {
        return ListView.builder(
            itemCount: listaEnvios.length,
            itemBuilder: (context, i) => crearItem(listaEnvios[i]));
      }
    }

    Widget tabs = ToggleButtons(
      borderColor: colorletra,
      fillColor: colorletra,
      borderWidth: 1,
      selectedBorderColor: colorletra,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Salida',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Entrada',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
          indexSwitch = index;
        });
      },
      isSelected: isSelected,
    );

    final campodetextoandIconoInicio = Row(children: <Widget>[
      Expanded(
        child: fechainicio,
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

    final campodetextoandIconoFin = Row(children: <Widget>[
      Expanded(
        child: fechafin,
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

    final campodetextoandIconoButton = Row(children: <Widget>[
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
    ]);

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 30),
                  width: double.infinity,
                  child: textInicio),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoInicio),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 30),
                  width: double.infinity,
                  child: textFin),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoFin),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.centerLeft,
                height: screenHeightExcludingToolbar(context, dividedBy: 12),
                width: double.infinity,
                child: campodetextoandIconoButton,
              ),
            ),
            !pressButton
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 20),
                    child: tabs),
            !pressButton
                ? Container()
                : Expanded(
                    child: Container(
                    child: _crearListadoAgregar(indexSwitch),
                    margin: const EdgeInsets.only(bottom: 5),
                  )),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: crearTitulo("Históricos"),
        drawer: crearMenu(context),
        body: scaffoldbody(mainscaffold(), context));
  }
}