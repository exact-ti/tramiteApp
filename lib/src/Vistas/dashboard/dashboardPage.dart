import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Enumerator/TipoEstadoEnum.dart';
import 'package:tramiteapp/src/ModelDto/Indicador.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'dashboardController.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => new _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardController dashboardController = new DashboardController();
  Indicador indicadorModel = new Indicador();
  @override
  void initState() {
    super.initState();
  }

  Widget tick(Indicador indicador, int modalidad) {
    Map<String, Object> objetoSend = {
      'modalidad': modalidad,
      'estadoid': indicador.id
    };
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(indicador.cantidad.toString()),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListarEnviosActivosPage(
                                  objetoModo: objetoSend),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ClipOval(
                          child: Material(
                            color: Colors.blue, 
                            child: SizedBox(width: 35, height: 35),
                          ),
                        ),
                      )),
                  Text(indicador.nombre,
                      style: TextStyle(
                          fontSize: 8,
                          decorationStyle: TextDecorationStyle.wavy,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal))
                ],
              ),
            )));
  }

  Widget line() {
    return Expanded(
        child: Container(
      color: Colors.blue,
      height: 5.0,
      width: 50.0,
    ));
  }

  Widget textModo(String texto) {
    return Container(
      child: Text("$texto",
          style: TextStyle(
              fontSize: 18,
              decorationStyle: TextDecorationStyle.wavy,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal)),
      alignment: Alignment.bottomLeft,
      height: screenHeightExcludingToolbar(context, dividedBy: 6),
    );
  }

  Widget contenidoItems() {
    return FutureBuilder(
        future: dashboardController.listarItems(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: new Text(
                      'No hay conexión con el servidor')); 
            case ConnectionState.waiting:
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadingGet(), 
              ));
            default:
              if (snapshot.hasError)
                return Center(child: new Text('Ha surgido un problema'));
              return futurowidget(snapshot.data);
          }
        });
  }

  Widget futurowidget(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        textModo("Entradas"),
        Container(
            margin: const EdgeInsets.only(top: 30),
            height: screenHeightExcludingToolbar(context, dividedBy: 6),
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: itemContent(data["entrada"], entrada),
            )),
        textModo("Salidas"),
        Container(
            margin: const EdgeInsets.only(top: 30),
            height: screenHeightExcludingToolbar(context, dividedBy: 6),
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: itemContent(data["salida"], salida),
            )),
      ],
    );
  }

  Widget itemContent(List<dynamic> data, int modalidad) {
    List<Indicador> indicadores = indicadorModel.fromJsonToIndicador(data);
    int tam = indicadores.length;
    List<Widget> listaWidget = new List();
    for (int i = 0; i < tam; i++) {
      Indicador indicador = indicadores[i];
      if (i != (tam - 1)) {
        listaWidget.add(tick(indicador, modalidad));
        listaWidget.add(line());
      } else {
        listaWidget.add(tick(indicador, modalidad));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listaWidget,
    );
  }

  Widget mainscaffold() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: contenidoItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Dashboard",leadingbool: boolIfPerfil()?false:true,),
        drawer: drawerIfPerfil(),
        backgroundColor: Colors.white,
        body: mainscaffold());
  }
}
