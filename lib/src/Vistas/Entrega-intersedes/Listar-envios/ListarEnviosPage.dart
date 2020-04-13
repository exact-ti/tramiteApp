import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nuevo-intersede/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ListarEnviosController.dart';

class ListarEnviosPage extends StatefulWidget {
  @override
  _ListarEnviosPageState createState() => _ListarEnviosPageState();
}

class _ListarEnviosPageState extends State<ListarEnviosPage> {
  ListarEnviosController principalcontroller = new ListarEnviosController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  var listadestinatarios;
  String textdestinatario = "";

  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;

  var nuevo = 0;

  @override
  void initState() {
    //listadetinatario= principalcontroller.ListarDestinario();
    prueba = Text("Usuarios frecuentes",
        style: TextStyle(fontSize: 15, color: Color(0xFFACADAD)));

    setState(() {
      //listadetinatario =principalcontroller.ListarDestinario();
      //listadetinatarioDisplay = listadetinatario;

      /* */

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
          height: 100,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 50,
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
                height: 50,
                child: Text("$numdocumentos documentos listos para enviar",
                    style: TextStyle(fontSize: 12))),
          ]));
    }

    Widget crearItem(EnvioInterSedeModel entrega) {
      return Container(
        decoration: myBoxDecoration(),
        margin: EdgeInsets.only(bottom: 5),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  height: 100,
                  padding: const EdgeInsets.only(right: 26, bottom: 30),
                  child: Center(
                      child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.cube,
                      color: Color(0xff000000),
                      size: 60,
                    ),
                    onPressed: () {
                      principalcontroller.onSearchButtonPressed(
                          context, entrega);
                    },
                  )))),
          Expanded(
            child: informacionEntrega(entrega),
            flex: 3,
          ),
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.locationArrow,
                              color: Color(0xffC7C7C7),
                              size: 25,
                            ),
                            onPressed: () {
                              principalcontroller.onSearchButtonPressed(
                                  context, entrega);
                            }))
                  ])),
        ]),
      );
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarentregasInterSedeController(),
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
          //Navigator.of(context).pushNamed('/entregas-pisos-propios');
        },
        color: Color(0xFF2C6983),
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        child: Text('Nuevo', style: TextStyle(color: Colors.white)),
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
          title: Text('Envios Intersedes',
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
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 8),
                    width: double.infinity,
                    child: sendButton),
              ),
              Container(
                child: Text("Se puede editar la entrega",
                    style: TextStyle(fontSize: 15, color: othercolor)),
                margin: const EdgeInsets.only(bottom: 10),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter, child: _crearListado()),
              )
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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }
}
