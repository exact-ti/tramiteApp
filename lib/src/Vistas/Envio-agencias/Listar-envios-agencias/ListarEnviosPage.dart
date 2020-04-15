import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
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
          decoration: myBoxDecoration2(),
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
                child: Text("$numdocumentos documentos listos para enviar",
                    style: TextStyle(fontSize: 12))),
          ]));
    }

    Widget crearItem(EnvioInterSedeModel entrega) {
      int codigoUtd = entrega.utdId;
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigoUtd"] = true;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(children: <Widget>[
               validados["$codigoUtd"] == null ?               Opacity(
                opacity: 0.0,
                child:Container(
                  child: Checkbox(
                value: validados["$codigoUtd"] == null ? false : true,
                onChanged: (bool value) {},
              )) ,
              ) : Container(
                  child: Checkbox(
                value: validados["$codigoUtd"] == null ? false : true,
                onChanged: (bool value) {},
              )) ,
              Container(
                  height: 70,
                  //padding: const EdgeInsets.only(right: 26, bottom: 30),
                  decoration: myBoxDecoration(),
                  child: Center(
                      child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.cube,
                      color: Color(0xff000000),
                      size: 30,
                    ),
                    onPressed: () {
                      principalcontroller.onSearchButtonPressed(
                          context, entrega);
                    },
                  ))),
              Expanded(
                child: informacionEntrega(entrega),
                flex: 3,
              ),
              Container(
                  decoration: myBoxDecoration3(),
                  height: 70,
                  child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.locationArrow,
                        color: Color(0xffC7C7C7),
                        size: 20,
                      ),
                      onPressed: () {
                        principalcontroller.onSearchButtonPressed(
                            context, entrega);
                      }))
            ]),
          ));
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
          //Navigator.of(context).pushNamed('/nueva-entrega-intersede');
        },
        color: Color(0xFF2C6983),
        child: Text('Nuevo', style: TextStyle(color: Colors.white)),
      ),
    );

    final botonessuperiores = Row(children: [
      Expanded(
        child: Text(
          'Grupo Agencias',
          style: TextStyle(
            fontSize: 15,
            color: othercolor,
          ),
        ),
        flex: 3,
      ),
      Expanded(
        child: sendButton,
      ),
    ]);

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
                    alignment: Alignment.bottomCenter,
                    height: screenHeightExcludingToolbar(context, dividedBy: 8),
                    width: double.infinity,
                    child: botonessuperiores),
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
      border: Border(
        top: BorderSide(color: colorletra),
        bottom: BorderSide(color: colorletra),
        left: BorderSide(color: colorletra),
      ),
      color: Colors.white,
    );
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(color: colorletra),
        bottom: BorderSide(color: colorletra),
      ),
      color: Colors.white,
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(color: colorletra),
        right: BorderSide(color: colorletra),
        bottom: BorderSide(color: colorletra),
      ),
      color: Colors.white,
    );
  }
}
