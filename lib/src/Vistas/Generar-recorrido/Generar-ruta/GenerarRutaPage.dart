import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/modals/confirmation.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Detalle-ruta/DetalleRutaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';

import 'GenerarRutaController.dart';

class GenerarRutaPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const GenerarRutaPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _GenerarRutaPageState createState() => _GenerarRutaPageState(recorridopage);
}

class _GenerarRutaPageState extends State<GenerarRutaPage> {
  RecorridoModel recorridoUsuario;
  _GenerarRutaPageState(this.recorridoUsuario);
  GenerarRutaController principalcontroller = new GenerarRutaController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  var listadestinatarios;
  String textdestinatario = "";
  int cantidad = 0;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;

  var nuevo = 0;

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
    const colorletra = const Color(0xFF7A7D7F);
    var booleancolor = true;
    var colorwidget = colorplomo;

    Widget informacionArea(String nombre) {
      return Container(
          alignment: Alignment.centerLeft,
          height: 80,
          child: Align(
              child: Text(
                "$nombre",
                style: TextStyle(fontSize: 11),
              ),
              alignment: Alignment(-1.2, 0.0)));
    }

    Widget informacionIcono(String nombre) {
      return Container(
          height: 80, child: Center(child: Icon(Icons.location_on)));
    }

    Widget informacionRecojo(RutaModel ruta) {
      int total = ruta.cantidadRecojo;

      return Container(
          alignment: Alignment.center,
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              child: new Center(
                  child: ListTile(
                      title: Text("Para recoger",
                          style: TextStyle(fontSize: 9)))),
            ),
            Center(
              child: Container(
                  height: 40,
                  child: Text("$total", style: TextStyle(fontSize: 11))),
            )
          ]));
    }

    Widget informacionEntrega(RutaModel ruta) {
      int total = ruta.cantidadEntrega;

      return Container(
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Center(
              child: Container(
                height: 40,
                child: ListTile(
                    title:
                        Text("Para Entrega", style: TextStyle(fontSize: 9))),
              ),
            ),
            Center(
              child: Container(
                  height: 40,
                  child: Text("$total", style: TextStyle(fontSize: 11))),
            )
          ]));
    }

    Widget crearItem(RutaModel ruta) {
      return InkWell(
          onTap: () {
            Map<String, Object> objetoSend = {
              'ruta': ruta,
              'recorridoId': this.recorridoUsuario.id
            };
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleRutaPage(objetoModo: objetoSend),
                ));
          },
          child: Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            height: 80,
            //color: colorwidget,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: informacionIcono(ruta.nombre),
                    flex: 2,
                  ),
                  Expanded(
                    child: informacionArea(ruta.nombre),
                    flex: 3,
                  ),
                  Expanded(
                    child: informacionRecojo(ruta),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: informacionEntrega(ruta),
                    ),
                    flex: 3,
                  ),
                ]),
          ));
    }

    Widget _crearListado() {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.listarMiRuta(recorridoUsuario.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<RutaModel>> snapshot) {
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
                    final rutas = snapshot.data;
                    if (rutas.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      this.cantidad=rutas.length;
                      return ListView.builder(
                          itemCount: rutas.length,
                          itemBuilder: (context, i) => crearItem(rutas[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    final textoRuta =
        Text("Tu ruta", style: TextStyle(fontSize: 20, color: colorletra));

    final sendBack = Container(
        margin: const EdgeInsets.only(top: 40, right: 5),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.grey,
              child: recorridoUsuario.indicepagina == 1
                  ? Text('Empezar recorrido',
                      style: TextStyle(color: Colors.white))
                  : Text('Retroceder', style: TextStyle(color: Colors.white))),
        ));

    final sendButton = Container(
        margin: recorridoUsuario.indicepagina != 1
            ? const EdgeInsets.only(top: 40, left: 5)
            : const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () async {
                if (recorridoUsuario.indicepagina != 1) {
                  if (this.cantidad != 0) {
                    bool respuestabool = await confirmacion(context, "success",
                        "EXACT", "Tienes pendientes ¿Desea Continuar?");
                    if (respuestabool) {
                      principalcontroller.opcionRecorrido(
                          recorridoUsuario, context);
                    }
                  } else {
                    principalcontroller.opcionRecorrido(
                        recorridoUsuario, context);
                  }
                } else {
                  principalcontroller.opcionRecorrido(
                      recorridoUsuario, context);
                }
              },
              color: Color(0xFF2C6983),
              child: recorridoUsuario.indicepagina == 1
                  ? Text('Empezar recorrido',
                      style: TextStyle(color: Colors.white))
                  : Text('Terminar', style: TextStyle(color: Colors.white))),
        ));

    final filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: sendBack,
            flex: 5,
          ),
          Expanded(flex: 5, child: sendButton)
        ],
      ),
    );
    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos"),
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
                            child: textoRuta),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: _crearListado()),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 4),
                            width: double.infinity,
                            child: recorridoUsuario.indicepagina != 1
                                ? filaBotones
                                : sendButton),
                      ),
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
