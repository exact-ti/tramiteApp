import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoController.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoPage.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class PaqueteExternoPage extends StatefulWidget {
  @override
  _PaqueteExternoPageState createState() => _PaqueteExternoPageState();
}

class _PaqueteExternoPageState extends State<PaqueteExternoPage> {

  PaqueteExternoController paqueteExternoController = new PaqueteExternoController();

  Widget _subtitulo() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 20,bottom: 20),
      width: double.infinity,
      child: Text('Elige el tipo de paquete', style: TextStyle(color: StylesThemeData.LETTERCOLOR)),
    );
  }

  Widget _crearListaTipoPaquete() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
            future: paqueteExternoController.listarPaquetesPorTipo(false),
            builder: (BuildContext context,
                AsyncSnapshot<List<TipoPaqueteModel>> snapshot) {
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
                      final tipoPaquetes = snapshot.data;
                      if (tipoPaquetes.length == 0) {
                        return sinResultados("No se han encontrado resultados");
                      } else {
                        return ListView.builder(
                            itemCount: tipoPaquetes.length,
                            itemBuilder: (context, i) =>
                                _crearItem(tipoPaquetes[i]));
                      }
                    } else {
                      return sinResultados("No se han encontrado resultados");
                    }
                  }
              }
            }),
      ),
    );
  }

  Widget _crearItem(TipoPaqueteModel item) {
    return Container(
        decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
        margin: EdgeInsets.only(bottom: 5),
        child: InkWell(
            onTap: () {
              _selectPaquete(item);
            },
            child: Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Expanded(
                    child: _informacionItem(item),
                    flex: 5,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 80,
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: StylesThemeData.LETTERCOLOR, size: 50))
                          ]))
                ]))));
  }

  void _selectPaquete(TipoPaqueteModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImportarArchivoPage(tipoPaqueteModel: item),
      ),
    );
  }

  Widget _informacionItem(TipoPaqueteModel item) {
    return Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
      Container(
          child: ListTile(
        title: Text("${item.nombre}"),
        leading: Icon(
          Icons.description,
          color:  StylesThemeData.LETTERCOLOR,
        ),
      )),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[_subtitulo(), _crearListaTipoPaquete()],
            ),
          ));
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Custodia de documentos externos"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
