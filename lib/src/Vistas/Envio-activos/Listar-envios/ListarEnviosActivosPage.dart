import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ListarEnviosActivosController.dart';


class ListarEnviosActivosPage extends StatefulWidget {
  @override
  _ListarEnviosActivosPageState createState() => _ListarEnviosActivosPageState();
}

class _ListarEnviosActivosPageState extends State<ListarEnviosActivosPage> {
  EnviosActivosController principalcontroller = new EnviosActivosController();
  EnvioController envioController = new EnvioController();
  List<EnvioModel> envios = new List();
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

    Widget crearItem(EnvioModel entrega, int switched) {
      String codigopaquete = entrega.codigoPaquete;
      String destinatario = entrega.usuario;
      String observacion = entrega.observacion;
      return  Container(
              height: 70,
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              decoration: myBoxDecoration(),
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      height: 35,
                      child: Text("Para $destinatario")),
                  Expanded(
                      child: Container(
                          child: Row(
                    children: <Widget>[
                           Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: Text("$codigopaquete",
                                    style: TextStyle(color: Colors.blue)),
                                onTap: () {
                                      trackingPopUp(context, codigopaquete);
                                },
                              )),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("En custodia en UTD $observacion")))
                    ],
                  )))
                ],
              ));
    }

    Widget _crearListado(int switched) {
      envios.clear();
      return FutureBuilder(
          future: principalcontroller.listarActivosController(switched),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnvioModel>> snapshot) {
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
        drawer: crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 40),
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
