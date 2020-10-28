import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'ListarEnviosController.dart';

class ListarEnviosPage extends StatefulWidget {
  @override
  _ListarEnviosPageState createState() => _ListarEnviosPageState();
}

class _ListarEnviosPageState extends State<ListarEnviosPage> {
  ListarEnviosController principalcontroller = new ListarEnviosController();
  List<bool> isSelected;
  int indexSwitch = 0;
  int numvalijas = 0;
  String codigo = "";

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  void iniciarEnvio(EnvioInterSedeModel entrega) async {
    bool respuesta =
        await principalcontroller.onSearchButtonPressed(context, entrega);
    if (respuesta) {
      notificacion(
          context, "success", "EXACT", "Se ha iniciado el envío correctamente");
      setState(() {
        indexSwitch = indexSwitch;
      });
    } else {
      notificacion(context, "error", "EXACT", "No se pudo iniciar la entrega");
    }
  }

  void actionButtonNuevo() {
    Navigator.of(context).pushNamed('/nueva-entrega-intersede');
  }

  void actionButtonRecepcionar() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionInterPage(recorridopage: null),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(EnvioInterSedeModel entrega, int switched) {
      if (switched == 0) {
        numvalijas = entrega.numvalijas;
      } else {
        codigo = entrega.codigo;
      }

      return Container(
          height: 70,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 35,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("${entrega.destino}",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: switched == 0
                              ? Text("$numvalijas valijas",
                                  style: TextStyle(fontSize: 12))
                              : Text("$codigo", style: TextStyle(fontSize: 12)),
                        ),
                      ]),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    height: 35,
                    child: Text("${entrega.numdocumentos} envíos",
                        style: TextStyle(fontSize: 12))),
              ]));
    }

    Widget iconoRecepcion(EnvioInterSedeModel entrega, BuildContext context) {
      return Container(
          height: 70,
          child: Center(
              child: FaIcon(
            FontAwesomeIcons.locationArrow,
            color: Color(0xffC7C7C7),
            size: 25,
          )));
    }

    Widget iconoEnvio(EnvioInterSedeModel entrega) {
      return Container(
          height: 70,
          child: entrega.estadoEnvio.id == creado
              ? Center(
                  child: FaIcon(
                  FontAwesomeIcons.locationArrow,
                  color: Color(0xffC7C7C7),
                  size: 25,
                ))
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
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () {
                if (switched == 0) {
                  iniciarEnvio(entrega);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecepcionInterPage(recorridopage: entrega),
                      ));
                }
              },
              child: Container(
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
              )));
    }

    Widget _crearListado(int switched) {
      return FutureBuilder(
          future:
              principalcontroller.listarentregasInterSedeController(switched),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnvioInterSedeModel>> snapshot) {
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
                    final envios = snapshot.data;
                    if (envios.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: envios.length,
                          itemBuilder: (context, i) =>
                              crearItem(envios[i], switched));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    final filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: CustomButton(
                  onPressed: actionButtonNuevo,
                  colorParam: StylesThemeData.PRIMARYCOLOR,
                  texto: "Nuevo")),
          Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: CustomButton(
                      onPressed: actionButtonRecepcionar,
                      colorParam: Colors.grey,
                      texto: "Recepcionar"))),
        ],
      ),
    );

    final tabs = ToggleButtons(
      borderColor: StylesThemeData.LETTERCOLOR,
      fillColor: StylesThemeData.LETTERCOLOR,
      borderWidth: 1,
      selectedBorderColor: StylesThemeData.LETTERCOLOR,
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

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[filaBotones],
                )),
            Container(child: tabs),
            Expanded(
              child: Container(
                  decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
                  child: _crearListado(indexSwitch)),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entregas interUTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
