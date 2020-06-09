import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
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
  List<EnvioInterSedeModel> envios = new List();
  //TextEditingController _rutController = TextEditingController();
  var listadestinatarios;
  String textdestinatario = "";
  List<bool> isSelected;
  int indexSwitch = 0;
  int numvalijas = 0;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  String codigo = "";

  var nuevo = 0;

  @override
  void initState() {
    isSelected = [true, false];
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

    Widget informacionEntrega(EnvioInterSedeModel entrega, int switched) {
      String destino = entrega.destino;
      int numdocumentos = entrega.numdocumentos;

      if (switched == 0) {
        numvalijas = entrega.numvalijas;
      } else {
        codigo = entrega.codigo;
      }

      return Container(
          height: 70,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
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
                      child: switched == 0
                          ? Text("$numvalijas valijas",
                              style: TextStyle(fontSize: 12))
                          : Text("$codigo",
                              style: TextStyle(fontSize: 12)),
                    ),
                  ]),
            ),
            Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                height: 35,
                child: Text("$numdocumentos envíos",
                    style: TextStyle(fontSize: 12))),
          ]));
    }

    void iniciarEnvio(EnvioInterSedeModel entrega) async {
      bool respuesta =
          await principalcontroller.onSearchButtonPressed(context, entrega);
      if (respuesta) {
        principalcontroller.confirmarAlerta(context,
            "Se ha iniciado el envío correctamente", "Inicio Correcto");
        setState(() {
          indexSwitch = indexSwitch;
        });
      } else {
        principalcontroller.confirmarAlerta(
            context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
      }
    }

    Widget iconoRecepcion(EnvioInterSedeModel entrega, BuildContext context) {
      return Container(
          height: 70,
          child: /*entrega.estadoEnvio == 1
              ? */IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Color(0xffC7C7C7),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecepcionInterPage(recorridopage: entrega),
                        ));
                  })
             /* : Opacity(
                  opacity: 0.0,
                  child: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Color(0xffC7C7C7),
                    size: 25,
                  ))*/);
    }

    Widget iconoEnvio(EnvioInterSedeModel entrega) {
      return Container(
          height: 70,
          child: entrega.estadoEnvio.id == creado
              ? IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Color(0xffC7C7C7),
                    size: 25,
                  ),
                  onPressed: () {
                    iniciarEnvio(entrega);
                  })
              : Opacity(
                  opacity: 0.0,
                  child: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Color(0xffC7C7C7),
                    size: 25,
                  )));
    }

    Widget crearItem(EnvioInterSedeModel entrega, int switched) {
      return Container(
        decoration: myBoxDecoration(),
        margin: EdgeInsets.only(bottom: 5),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  height: 70,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.cube,
                    color: Color(0xff000000),
                    size: 40,
                  )))),
          Expanded(
            child: informacionEntrega(entrega, switched),
            flex: 3,
          ),
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    switched == 0
                        ? iconoEnvio(entrega)
                        : iconoRecepcion(entrega, context)
                  ])),
        ]),
      );
    }

    Widget _crearListado(int switched) {

      envios.clear();

      return FutureBuilder(
          future: principalcontroller.listarentregasInterSedeController(switched),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnvioInterSedeModel>> snapshot) {
            if (snapshot.hasData) {
              envios = snapshot.data;
              return ListView.builder(
                  itemCount: envios.length,
                  itemBuilder: (context, i) =>
                      crearItem(envios[i], switched));
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
          Navigator.of(context).pushNamed('/nueva-entrega-intersede');
        },
        color: Color(0xFF2C6983),
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        child: Text('Nuevo', style: TextStyle(color: Colors.white)),
      ),
    );

    final tabs = ToggleButtons(
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
            'Enviados',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Por recibir',
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
          title: Text('Entregas InterUTD',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: sd.crearMenu(context),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                  height: screenHeightExcludingToolbar(context, dividedBy: 20),
                  child: tabs),
              Expanded(
                child: Container(
                    decoration: myBoxDecoration(),
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    alignment: Alignment.bottomCenter,
                    child: _crearListado(indexSwitch)),
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
