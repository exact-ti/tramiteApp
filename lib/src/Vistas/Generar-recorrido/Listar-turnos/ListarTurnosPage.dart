import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'ListarTurnosController.dart';

class ListarTurnosPage extends StatefulWidget {
  @override
  _ListarTurnosPageState createState() => _ListarTurnosPageState();
}

class _ListarTurnosPageState extends State<ListarTurnosPage> {
  ListarTurnosController principalcontroller = new ListarTurnosController();

  @override
  void initState() {
    super.initState();
  }

  void redirectButtom() {
    Navigator.of(context).pushNamed('/entregas-pisos-propios');
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(EntregaModel entrega) {
      return Container(
          height: 100,
          child: ListView(
              shrinkWrap: false,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 20,
                  child: ListTile(title: Text("${entrega.nombreTurno}")),
                ),
                Container(
                    height: 20,
                    child: ListTile(
                        title: Text("${entrega.estado.nombreEstado}",
                            style: TextStyle(fontSize: 11)))),
                Container(
                    height: 20,
                    child: ListTile(
                      title: Text("${entrega.usuario}"),
                      leading: Icon(
                        Icons.perm_identity,
                        color: Color(0xffC7C7C7),
                      ),
                    )),
              ]));
    }

    Widget crearItem(EntregaModel entrega) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
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
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: CustomButton(
                    onPressed: redirectButtom,
                    colorParam: StylesThemeData.PRIMARYCOLOR,
                    texto: "Nuevo Recorrido")),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter, child: _crearListado()),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
