import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-propios/recorridoPropioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class RecorridosPropiosPage extends StatefulWidget {
  @override
  _RecorridosPropiosPageState createState() => _RecorridosPropiosPageState();
}

class _RecorridosPropiosPageState extends State<RecorridosPropiosPage> {
  RecorridoPropioController principalcontroller = new RecorridoPropioController();

  @override
  void initState() {
    super.initState();
  }

  void _onSearchButtonPressed() {
    Navigator.of(context).pushNamed('/entregas-pisos-adicionales');
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(RecorridoModel envio) {
      String horario = envio.horaInicio + " - " + envio.horaFin;

      return Container(
          height: 100,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 20,
                  child: ListTile(title: Text("${envio.nombre}")),
                ),
                Container(
                    height: 20,
                    child: ListTile(
                        title:
                            Text("$horario", style: TextStyle(fontSize: 11)))),
                Container(
                    height: 20,
                    child: ListTile(
                      title: Text("${envio.usuario}"),
                      leading: Icon(
                        Icons.perm_identity,
                        color: StylesThemeData.LETTERCOLOR,
                      ),
                    )),
              ]));
    }

    Widget crearItem(RecorridoModel entrega) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ValidacionEnvioPage(recorridopage: entrega),
                  ),
                );
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
                                        color: StylesThemeData.LETTERCOLOR, size: 50))
                              ])),
                    ]),
              )));
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarentregasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
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

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Elige el recorrido',
                            style:
                                TextStyle(color: StylesThemeData.LETTERCOLOR)),
                        flex: 5,
                      ),
                      Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              _onSearchButtonPressed();
                            },
                            child: Text(
                              'Más recorridos',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )),
                    ])),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter, child: _crearListado()),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos programados"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
