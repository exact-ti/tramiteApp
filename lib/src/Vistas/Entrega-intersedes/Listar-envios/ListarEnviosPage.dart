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
              height: 50,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: Text("$destino",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Text("$numvalijas valijas"),
                      flex: 5,
                    ),
                  ]),
            ),
            Container(
                height: 50,
                child: ListTile(
                    title: Text("$numdocumentos documentos listos para enviar",
                        style: TextStyle(fontSize: 11)))),
          ]));
    }

    Widget crearItem(EnvioInterSedeModel entrega) {
      //String nombrearea = usuario.area;
      //String nombresede = usuario.sede;
      if (booleancolor) {
        colorwidget = colorplomo;
        booleancolor = false;
      } else {
        colorwidget = colorblanco;
        booleancolor = true;
      }
      return Container(
        decoration: myBoxDecoration(),
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.cube,
                                  color: Color(0xffC7C7C7),
                                  size: 50,
                                ),
                                onPressed: onSearchButtonPressed(entrega)))
                      ])),
              Expanded(
                child: informacionEntrega(entrega),
                flex: 5,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.locationArrow,
                                  color: Color(0xffC7C7C7),
                                  size: 50,
                                ),
                                onPressed: onSearchButtonPressed(entrega)))
                      ])),
            ]),
      );
    }

    Widget crearItemVacio() {
      return Container();
    }

    Widget _crearListado() {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.listarentregasInterSedeController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnvioInterSedeModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
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
        //margin: const EdgeInsets.only(top: 10),
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/entregas-pisos-propios');
        },
        color: Color(0xFF2C6983),
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: Text('Nuevo', style: TextStyle(color: Colors.white)),
      ),
    ));

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
                    height: screenHeightExcludingToolbar(context, dividedBy: 6),
                    width: double.infinity,
                    child: sendButton),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: Text("Se puede editar la entrega")),
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

  onSearchButtonPressed(EnvioInterSedeModel enviomodel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoIntersedePage(envioInterSede: enviomodel),
      ),
    );
  }
}
