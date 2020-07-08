import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Envio-agencias-externas/Nueva-entrega-externa/NuevaEntregaExternaPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ListarEnviosAgenciasController.dart';

class ListarEnviosAgenciasPage extends StatefulWidget {
  @override
  _ListarEnviosAgenciasPageState createState() =>
      _ListarEnviosAgenciasPageState();
}

class _ListarEnviosAgenciasPageState extends State<ListarEnviosAgenciasPage> {
  ListarEnviosAgenciasController principalcontroller =
      new ListarEnviosAgenciasController();
  EnvioController envioController = new EnvioController();
  Map<String, dynamic> validados = new HashMap();
  String textdestinatario = "";
  var colorletra = const Color(0xFFACADAD);
  var colorseleccion = const Color(0xFF6DA1BB);
  List<EnvioInterSedeModel> enviosvalidados = new List();

  var prueba;
  var inicio = false;
  var nuevo = 0;
  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  @override
  void initState() {
    setState(() {
      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);
    const othercolor = const Color(0xFF6F7375);

    var booleancolor = true;
    var colorwidget = colorplomo;

    Widget informacionEntrega(EnvioInterSedeModel entrega) {
      String destino = entrega.destino;
      int numvalijas = entrega.numvalijas;
      int numdocumentos = entrega.numdocumentos;

      return Container(
          height: 70,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 35,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("$destino",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text("$numvalijas valijas",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ]),
            ),
            Container(
                padding: const EdgeInsets.only(left: 10, top: 10),
                height: 35,
                child: Text("$numdocumentos destinos",
                    style: TextStyle(fontSize: 12))),
          ]));
    }

    void iniciarItem(EnvioInterSedeModel entrega) async {
      List<String> listids = new List();
      int idutd = entrega.utdId;
      listids.add("$idutd");
      bool respuesta = await principalcontroller.registrarlista(context, listids);
      if (respuesta) {
        mostrarAlerta(
            context, "Se inició la entrega correctamente", "Inicio correcto");
        setState(() {
          textdestinatario = textdestinatario;
        });
      } else {
        mostrarAlerta(
            context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
      }
    }

    Widget crearItem(EnvioInterSedeModel entrega) {
      String codigoUtd = entrega.codigo;
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigoUtd"] = true;
            });
          },
          onTap: () {
            bool contienevalidados = validados.containsValue(true);
            if (contienevalidados && validados["$codigoUtd"] == false) {
              setState(() {
                validados["$codigoUtd"] = true;
              });
            } else {
              setState(() {
                validados["$codigoUtd"] = false;
              });
            }
          },
          child: Container(
            decoration: myBoxDecoration(validados["$codigoUtd"]),
            /* color:  validados["$codigoUtd"] ==false ? Colors.white : Colors.black,*/
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(children: <Widget>[
              Expanded(
                child: Container(
                    height: 70,
                    child: Center(
                        child: FaIcon(
                      FontAwesomeIcons.cube,
                      color: Color(0xff000000),
                      size: 30,
                    ))),
                flex: 1,
              ),
              Expanded(
                child: informacionEntrega(entrega),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  height: 70,
                  child: Center(
                    child: validados["$codigoUtd"] == null ||
                            validados["$codigoUtd"] == false
                        ? IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              if (!validados.containsValue(true)) {
                                iniciarItem(entrega);
                              }
                            })
                        : FaIcon(
                            FontAwesomeIcons.locationArrow,
                            color: Colors.black,
                            size: 20,
                          ),
                  ),
                ),
                flex: 1,
              ),
            ]),
          ));
    }

    Widget _crearListado(String codigo) {
      return FutureBuilder(
          future: principalcontroller.listarAgenciasExternasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnvioInterSedeModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              final entregas = snapshot.data;
              return ListView.builder(
                  itemCount: entregas.length,
                  itemBuilder: (context, i) => crearItem(entregas[i]));
            } else {
              return Container();
            }
          });
    }

    final sendButton = Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NuevoEntregaExternaPage(),
              ));
        },
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Color(0xFF2C6983),
        child: Text('Nueva', style: TextStyle(color: Colors.white)),
      ),
    );

    void registrarlista() async {
      List<String> listid = new List();
      validados
          .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));
      bool respuesta = await principalcontroller.registrarlista(context, listid);

      if (respuesta) {
        mostrarAlerta(
            context, "Se inició la entrega correctamente", "Inicio correcto");
        setState(() {
          validados.clear();
          textdestinatario = textdestinatario;
        });
      } else {
        mostrarAlerta(
            context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
      }
    }

    final sendButton2 = Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          registrarlista();
        },
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Color(0xFF2C6983),
        child: Text('Enviar', style: TextStyle(color: Colors.white)),
      ),
    );

    const PrimaryColor = const Color(0xFF2C6983);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Envío Agencias',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: sd.crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*Container(
                child: Text("Envío a agencias",
                    style: TextStyle(fontSize: 30, color: othercolor,)),
                margin: const EdgeInsets.only(bottom: 10,top: 30),
              ),*/
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 8),
                    width: double.infinity,
                    child: sendButton),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: _crearListado(textdestinatario)),
              ),
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
                  : Container(),
            ],
          ),
        ));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  BoxDecoration myBoxDecoration(bool seleccionado) {
    return BoxDecoration(
      border: Border.all(color: colorletra),
      color: seleccionado == null || seleccionado == false
          ? Colors.white
          : colorseleccion,
    );
  }
}
