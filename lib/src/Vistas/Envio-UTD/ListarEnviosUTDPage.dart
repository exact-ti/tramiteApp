import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'ListarEnviosUTDController.dart';

class ListarEnviosUTDPage extends StatefulWidget {
  @override
  _ListarEnviosUTDPageState createState() => _ListarEnviosUTDPageState();
}

class _ListarEnviosUTDPageState extends State<ListarEnviosUTDPage> {
  EnviosUTDController principalcontroller = new EnviosUTDController();
  List<EnvioModel> envios = new List();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(EnvioModel entrega) {
      return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("${entrega.destinatario}"),
                  )
                ],
              ))),
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Text("${entrega.codigoPaquete}",
                            style: TextStyle(color: Colors.blue)),
                        onTap: () {
                          trackingPopUp(context, entrega.id);
                        },
                      )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("${entrega.observacion}")))
                ],
              )))
            ],
          ));
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarUTDController(),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
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
                          itemBuilder: (context, i) => crearItem(envios[i]));
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
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: _crearListado()),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Envíos en UTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
