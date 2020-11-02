import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'DetalleRutaController.dart';

class DetalleRutaPage extends StatefulWidget {
  final dynamic objetoModo;
  const DetalleRutaPage({Key key, this.objetoModo}) : super(key: key);

  @override
  _DetalleRutaPagePageState createState() =>
      _DetalleRutaPagePageState(this.objetoModo);
}

class _DetalleRutaPagePageState extends State<DetalleRutaPage> {
  dynamic objetoModo;
  int recorridoID;
  RutaModel rutaModel;
  _DetalleRutaPagePageState(this.objetoModo);
  DetalleRutaController principalcontroller = new DetalleRutaController();
  List<DetalleRutaModel> detallesRuta = new List();
  List<bool> isSelected;
  int indexSwitch = 0;

  @override
  void initState() {
    isSelected = [true, false];
    this.recorridoID = objetoModo["recorridoId"];
    this.rutaModel = objetoModo["ruta"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(DetalleRutaModel detalleRutaModel, int switched) {
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
                    child: Text("${detalleRutaModel.destinatario}"),
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
                        child: Text("${detalleRutaModel.paqueteId}",
                            style: TextStyle(color: Colors.blue)),
                        onTap: () {
                          trackingPopUp(context, detalleRutaModel.id);
                        },
                      ))
                ],
              )))
            ],
          ));
    }

    Widget informacionArea() {
      return Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Text('Área:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${rutaModel.nombre}'),
                    flex: 5,
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Ubicación:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${rutaModel.ubicacion}'),
                    flex: 5,
                  ),
                ],
              ))
        ],
      ));
    }

    Widget _crearListado(int switched) {
      detallesRuta.clear();
      return FutureBuilder(
          future: principalcontroller.listarDetalleRuta(
              switched, rutaModel.id, recorridoID),
          builder: (BuildContext context,
              AsyncSnapshot<List<DetalleRutaModel>> snapshot) {
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
                    detallesRuta = snapshot.data;
                    if (detallesRuta.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: detallesRuta.length,
                          itemBuilder: (context, i) =>
                              crearItem(detallesRuta[i], switched));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    Widget tabs = ToggleButtons(
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
            'Por Entregar',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Por recoger',
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
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child: informacionArea()),
            Container(child: tabs),
            Expanded(
              child: Container(
                  decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: _crearListado(indexSwitch)),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Detalle de mi ruta"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
