import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'RecepcionController.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';

class RecepcionEnvioPage extends StatefulWidget {
  @override
  _RecepcionEnvioPageState createState() => new _RecepcionEnvioPageState();
}

class _RecepcionEnvioPageState extends State<RecepcionEnvioPage> {
  final _bandejaController = TextEditingController();
  List<String> listaEnvios = new List();
  List<EnvioModel> listaEnviosModel = new List();
  RecepcionController principalcontroller = new RecepcionController();
  Map<String, dynamic> validados = new HashMap();
  String qrsobre, qrbarra = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  var listadetinatario;
  var colorletra = const Color(0xFFACADAD);
  bool respuestaBack = false;
  var colorseleccion = const Color(0xFFB7DCEE);
  final NavigationService _navigationService = locator<NavigationService>();
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    inicializarEnviosRecepcion();
    super.initState();
  }

  inicializarEnviosRecepcion() async {
    listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
    listaEnviosModel.forEach((element) {
      String cod = element.codigoPaquete;
      validados["$cod"] = false;
    });
    setState(() {
      respuestaBack = true;
      listaEnviosModel = listaEnviosModel;
    });
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);

    Widget crearItem(EnvioModel entrega) {
      String codigopaquete = entrega.codigoPaquete;
      String destinatario = entrega.usuario;
      String observacion = entrega.observacion;
      int id = entrega.id;
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigopaquete"] = true;
            });
          },
          onTap: () {
            bool contienevalidados = validados.containsValue(true);
            if (contienevalidados && validados["$codigopaquete"] == false) {
              setState(() {
                validados["$codigopaquete"] = true;
              });
            } else {
              setState(() {
                validados["$codigopaquete"] = false;
              });
            }
          },
          child: Container(
              height: 70,
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              decoration: myBoxDecorationselect(validados["$codigopaquete"]),
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        /*defining default style is optional */
                        children: <TextSpan>[
                          TextSpan(
                              text: 'De',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                          TextSpan(
                              text: ' $destinatario',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          child: Row(
                    children: <Widget>[
                      validados["$codigopaquete"] == null ||
                              validados["$codigopaquete"] == false
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: Text("$codigopaquete",
                                    style: TextStyle(color: Colors.blue)),
                                onTap: () {
                                  if (!validados.containsValue(true)) {
                                    trackingPopUp(context, id);
                                  }
                                },
                              ))
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: Text("$codigopaquete",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("$observacion")))
                    ],
                  )))
                ],
              )));
    }

    void validarEnvio(List<String> listid, int cantidad) async {
      bool respuestaLista =
          await principalcontroller.guardarLista(context, listid);
      if (respuestaLista) {
        notificacion(
            context,
            "success",
            "EXACT",
            cantidad == 1
                ? "Se recepcionó el envío"
                : "Se recepcionó los envíos");
        _navigationService.showModal();
        listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
         validados.clear();
        listaEnviosModel.forEach((element) {
          String cod = element.codigoPaquete;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          validados=validados;
          _bandejaController.text = "";
          listaEnviosModel = listaEnviosModel;
        });
      } else {
        notificacion(
            context,
            "error",
            "EXACT",
            cantidad == 1
                ? "No es posible procesar el código"
                : "No es posible procesar los códigos");
        validados.clear();
        setState(() {
          _bandejaController.text = "";
        });
      }
    }

    void _validarBandejaText(String value) {
      if (value != "") {
        List<String> lista = new List();
        lista.add(value);
        validarEnvio(lista, 1);
      }
    }

    Future _traerdatosescanerBandeja() async {
      if (!validados.containsValue(true)) {
        qrbarra = await getDataFromCamera();
        _validarBandejaText(qrbarra);
      }
    }

    void registrarLista() {
      List<String> listid = new List();
      validados
          .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));
      validarEnvio(listid, 2);
    }

    final sendButton2 = Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          registrarLista();
        },
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Color(0xFF2C6983),
        child: Text('Recepcionar', style: TextStyle(color: Colors.white)),
      ),
    );

    Widget _crearListado(List<EnvioModel> listaEnv) {
      if (listaEnv.length == 0)
        return Container(
            child:
                Center(child: sinResultados("No hay envíos para recepcionar")));
      return ListView.builder(
          itemCount: listaEnv.length,
          itemBuilder: (context, i) => crearItem(listaEnv[i]));
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
/*       focusNode: f1,
 */
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (!validados.containsValue(true)) {
          _validarBandejaText(value);
        } else {
          _bandejaController.text = "";
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
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Confirmar envíos',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
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
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: principalcontroller.labeltext("Envío")),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoBandeja),
                      ),
                      !respuestaBack
                          ? Expanded(
                              child: Container(
                                  child: Center(
                                      child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: loadingGet(),
                            ))))
                          : Expanded(
                              child: Container(
                                  child: _crearListado(listaEnviosModel))),
                      validados.containsValue(true)
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.center,
                                  height: screenHeightExcludingToolbar(context,
                                      dividedBy: 8),
                                  width: double.infinity,
                                  child: sendButton2),
                            )
                          : Container()
                    ],
                  ),
                ))));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  BoxDecoration myBoxDecorationselect(bool seleccionado) {
    return BoxDecoration(
      border: Border.all(color: colorletra),
      color: seleccionado == null || seleccionado == false
          ? Colors.white
          : colorseleccion,
    );
  }
}
