import 'dart:collection';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Envio-agencias-externas/Nueva-entrega-externa/NuevaEntregaExternaPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'ListarEnviosAgenciasController.dart';

final NavigationService _navigationService = locator<NavigationService>();

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
  var colorseleccion = const Color(0xFF6DA1BB);
  List<EnvioInterSedeModel> enviosvalidados = new List();
  bool respuestaBack = false;

  @override
  void initState() {
    inicializarEnviosRecepcion();
    super.initState();
  }

  inicializarEnviosRecepcion() async {
    enviosvalidados =
        await principalcontroller.listarAgenciasExternasController();
    enviosvalidados.forEach((element) {
      int cod = element.utdId;
      validados["$cod"] = false;
    });
    setState(() {
      respuestaBack = true;
      enviosvalidados = enviosvalidados;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(EnvioInterSedeModel entrega) {
      String destino = entrega.destino;
      int numvalijas = entrega.numvalijas;
      int numdocumentos = entrega.numdocumentos;

      return Container(
          height: 70,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
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
      bool respuesta =
          await principalcontroller.registrarlista(context, listids);
      if (respuesta) {
        notificacion(
            context, "success", "EXACT", "Se inició la entrega correctamente");
        _navigationService.showModal();
        enviosvalidados =
            await principalcontroller.listarAgenciasExternasController();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          enviosvalidados = enviosvalidados;
        });
      } else {
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }

    Widget crearItem(EnvioInterSedeModel entrega) {
      String codigoUtd = entrega.utdId.toString();
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
              margin: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                  onTap: () {
                    bool contienevalidados = validados.containsValue(true);
                    if (contienevalidados) {
                      if (contienevalidados &&
                          validados["$codigoUtd"] == false) {
                        setState(() {
                          validados["$codigoUtd"] = true;
                        });
                      } else {
                        setState(() {
                          validados["$codigoUtd"] = false;
                        });
                      }
                    } else {
                      if (!validados.containsValue(true)) {
                        iniciarItem(entrega);
                      }
                    }
                  },
                  child: Container(
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
                                ? FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: Colors.black,
                                    size: 20,
                                  )
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
                  ))));
    }

    Widget _crearListado(List<EnvioInterSedeModel> envios) {
      if (envios.length == 0) {
        return Container(
            child: Center(child: sinResultados("No hay envíos para agencias")));
      } else {
        return ListView.builder(
            itemCount: envios.length,
            itemBuilder: (context, i) => crearItem(envios[i]));
      }
    }

    final sendButton = Container(
      child: ButtonTheme(
        minWidth: 150.0,
        height: 50.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NuevoEntregaExternaPage(),
                  ));
            },
            color: Color(0xFF2C6983),
            child: Text('Nueva', style: TextStyle(color: Colors.white))),
      )
      ,
    );

    void registrarlista() async {
      List<String> listid = new List();
      validados
          .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));

      bool respuesta =
          await principalcontroller.registrarlista(context, listid);
      if (respuesta) {
        notificacion(
            context, "success", "EXACT", "Se inició la entrega correctamente");
        _navigationService.showModal();

        validados.clear();
        enviosvalidados =
            await principalcontroller.listarAgenciasExternasController();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          enviosvalidados = enviosvalidados;
          validados = validados;
        });
      } else {
        validados.clear();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        setState(() {
          enviosvalidados = enviosvalidados;
          validados = validados;
        });
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }

    final sendButton2 = Container(
      child: ButtonTheme(
        minWidth: 150.0,
        height: 50.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              registrarlista();
            },
            color: Color(0xFF2C6983),
            child: Text('Enviar', style: TextStyle(color: Colors.white))),
      ) /* RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          registrarlista();
        },
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Color(0xFF2C6983),
        child: Text('Enviar', style: TextStyle(color: Colors.white)),
      ) */
      ,
    );

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 8),
                  width: double.infinity,
                  child: sendButton),
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
                        alignment: Alignment.bottomCenter,
                        child: _crearListado(enviosvalidados)),
                  ),
            validados.containsValue(true)
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        alignment: Alignment.center,
                        height:
                            screenHeightExcludingToolbar(context, dividedBy: 8),
                        width: double.infinity,
                        child: sendButton2),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entregas externas") ,
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
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
