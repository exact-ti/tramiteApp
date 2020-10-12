import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';

import 'ListarTurnosController.dart';

class ListarTurnosPage extends StatefulWidget {
  @override
  _ListarTurnosPageState createState() => _ListarTurnosPageState();
}

class _ListarTurnosPageState extends State<ListarTurnosPage> {
  ListarTurnosController principalcontroller = new ListarTurnosController();
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
    prueba = Text("Usuarios frecuentes",
        style: TextStyle(fontSize: 15, color: Color(0xFFACADAD)));

    setState(() {
      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var booleancolor = true;

    Widget informacionEntrega(EntregaModel entrega) {
      String recorrido = entrega.nombreTurno;
      String estado = entrega.estado.nombreEstado;
      String usuario = entrega.usuario;

      return Container(
          height: 100,
          child: ListView(
              shrinkWrap: false,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 20,
                  child: ListTile(title: Text("$recorrido")),
                ),
                Container(
                    height: 20,
                    child: ListTile(
                        title:
                            Text("$estado", style: TextStyle(fontSize: 11)))),
                Container(
                    height: 20,
                    child: ListTile(
                      title: Text("$usuario"),
                      leading: Icon(
                        Icons.perm_identity,
                        color: Color(0xffC7C7C7),
                      ),
                    )),
              ]));
    }

    Widget crearItem(EntregaModel entrega) {
      if (booleancolor) {
        booleancolor = false;
      } else {
        booleancolor = true;
      }
      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () {
                principalcontroller.onSearchButtonPressed(context, entrega);
              },
              child: Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: informacionEntrega(entrega),
                        flex: 5,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 100,
                                    child: Icon(Icons.keyboard_arrow_right,
                                        color: Color(0xffC7C7C7), size: 50))
                              ])),
                    ]),
              )));
    }

    Widget _crearListado() {
      booleancolor = true;
      return FutureBuilder(
          future: principalcontroller.listarentregasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EntregaModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor");
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados("Ha surgido un problema");
                } else {
                  if (snapshot.hasData) {
                    booleancolor = true;
                    final entregas = snapshot.data;
                    if (entregas.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: entregas.length,
                          itemBuilder: (context, i) => crearItem(entregas[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    final sendButton = Container(
        child: ButtonTheme(
        minWidth: 150.0,
        height: 50.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: ()  {
          Navigator.of(context).pushNamed('/entregas-pisos-propios');

            },
            color: Color(0xFF2C6983),
            child: Text('Nuevo Recorrido', style: TextStyle(color: Colors.white))),
      ));
    return Scaffold(
        appBar:CustomAppBar(text: "Entregas en sede"),
        drawer: DrawerPage(),
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
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 6),
                            width: double.infinity,
                            child: sendButton),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: _crearListado()),
                      )
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
