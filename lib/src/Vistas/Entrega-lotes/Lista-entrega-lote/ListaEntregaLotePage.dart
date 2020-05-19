import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLoteController.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Nueva-entrega-lote/NuevaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart';
// import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart'

class ListaEntregaLotePage extends StatefulWidget {
  @override
  _ListaEntregaLotePageState createState() => new _ListaEntregaLotePageState();
}

class _ListaEntregaLotePageState extends State<ListaEntregaLotePage> {
  ListaEntregaLoteController listarLoteController =
      new ListaEntregaLoteController();

  final titulo = 'Entregas de Lotes';
  String textdestinatario = "";
  List<bool> isSelected;
  int indexSwitch = 0;
  List<EntregaLoteModel> entregas = new List();
  // int numvalijas = 0;

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
    Widget informacionEntrega(EntregaLoteModel entrega, int switched) {
      String destino = entrega.udtNombre;
      int numvalijas = entrega.cantLotes;
      int numenvios = 0;
      String codigo = "";
      if (switched == 0) {
        numenvios = entrega.cantLotes;
      } else {
        codigo = entrega.paqueteId;
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
                      padding: const EdgeInsets.only(left: 20),
                      child: switched == 0
                          ? Container()
                          : Text("$codigo",
                              style: TextStyle(fontSize: 10)),
                    ),
                  ]),
            ),
            Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                height: 35,
                child: Text("$numvalijas valijas",
                    style: TextStyle(fontSize: 12))),
          ]));
    }

    // void iniciarEnvio(EnvioInterSedeModel entrega) async {
    //   bool respuesta =
    //       await principalcontroller.onSearchButtonPressed(context, entrega);
    //   if (respuesta) {
    //     principalcontroller.confirmarAlerta(context,
    //         "Se ha iniciado el envío correctamente", "Inicio Correcto");
    //     setState(() {
    //       indexSwitch = indexSwitch;
    //     });
    //   } else {
    //     principalcontroller.confirmarAlerta(
    //         context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
    //   }
    // }

    Widget iconoRecepcion(EntregaLoteModel entregaLote, BuildContext context) {
      return Container(
          height: 70,
          child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.locationArrow,
                color: Color(0xffC7C7C7),
                size: 25,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecepcionEntregaLotePage(
                          entregaLotepage: entregaLote),
                    ));
              }));
    }

    void iniciarEnvioLote(EntregaLoteModel entrega) async {
      bool respuesta =
          await listarLoteController.onSearchButtonPressed(context, entrega);
      if (respuesta) {
        listarLoteController.confirmarAlerta(context,
            "Se ha iniciado el envío correctamente", "Inicio Correcto");
        setState(() {
          indexSwitch = indexSwitch;
        });
      } else {
        listarLoteController.confirmarAlerta(
            context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
      }
    }

    Widget iconoEnvio(EntregaLoteModel entrega) {
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
                    iniciarEnvioLote(entrega);
                  })
              : Opacity(
                  opacity: 0.0,
                  child: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Color(0xffC7C7C7),
                    size: 25,
                  )));
    }

    Widget crearItem(EntregaLoteModel entrega, int switched) {
      return Container(
        decoration: sd.myBoxDecoration(sd.colorletra),
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
      entregas.clear();

      return FutureBuilder(
          future: listarEntregas(switched),
          builder: (BuildContext context,
              AsyncSnapshot<List<EntregaLoteModel>> snapshot) {
            if (snapshot.hasData) {
              entregas = snapshot.data;
              return ListView.builder(
                  itemCount: entregas.length,
                  itemBuilder: (context, i) =>
                      crearItem(entregas[i], switched));
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
              builder: (context) => NuevoEntregaLotePage(),
            ),
          );
        },
        color: Color(0xFF2C6983),
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        child: Text('Nuevo', style: TextStyle(color: Colors.white)),
      ),
    );

    final tabs = ToggleButtons(
      borderColor: sd.colorletra,
      fillColor: sd.colorletra,
      borderWidth: 1,
      selectedBorderColor: sd.colorletra,
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

    return Scaffold(
      appBar: sd.crearTitulo(titulo),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height:
                      sd.screenHeightExcludingToolbar(context, dividedBy: 8),
                  width: double.infinity,
                  child: sendButton),
            ),
            Container(
                height: sd.screenHeightExcludingToolbar(context, dividedBy: 20),
                child: tabs),
            Expanded(
              child: Container(
                  decoration: sd.myBoxDecoration(sd.colorletra),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: _crearListado(indexSwitch)),
            )
          ],
        ),
      ),
    );
  }

  Future<List<EntregaLoteModel>> listarEntregas(int op) async {
    List<EntregaLoteModel> elm = new List();

    if (op == 0) {
      elm = await listarLoteController.listarLotesActivos();
    } else {
      elm = await listarLoteController.listarLotesPorRecibir();
    }

    return elm;
  }
}
