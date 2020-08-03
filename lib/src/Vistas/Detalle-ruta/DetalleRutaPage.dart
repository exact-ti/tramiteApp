import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';
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
  List<EstadoEnvio> estadosSave = new List();
  List<DetalleRutaModel> detallesRuta = new List();
  List<int> estadosIds = new List();
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
    this.recorridoID=objetoModo["recorridoId"];
    this.rutaModel=objetoModo["ruta"];
    setState(() {
      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(DetalleRutaModel detalleRutaModel, int switched) {
      String codigopaquete = detalleRutaModel.paqueteId;
      String destinatario = detalleRutaModel.destinatario;

      return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: myBoxDecoration(colorletra),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("$destinatario"),
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
                        child: Text("$codigopaquete",
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
      String nombrearea = rutaModel.nombre;
      String ubicacion = rutaModel.ubicacion;
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
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('$nombrearea'),
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
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold/* , fontSize: 15 */)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('$ubicacion'),
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
          future:
              principalcontroller.listarDetalleRuta(switched, rutaModel.id,recorridoID),
          builder:
              (BuildContext context, AsyncSnapshot<List<DetalleRutaModel>> snapshot) {
            if (snapshot.hasData) {
              detallesRuta = snapshot.data;
              return ListView.builder(
                  itemCount: detallesRuta.length,
                  itemBuilder: (context, i) => crearItem(detallesRuta[i], switched));
            } else {
              return Container();
            }
          });
    }

    Widget tabs = ToggleButtons(
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
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 10),
                  width: double.infinity,
                  child: informacionArea()),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                height: screenHeightExcludingToolbar(context, dividedBy: 20),
                child: tabs),
            Expanded(
              child: Container(
                  decoration: myBoxDecoration(colorletra),
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
        appBar: crearTitulo("Detalle de mi ruta"),
        drawer: crearMenu(context),
        body: scaffoldbody(mainscaffold(), context));
  }
}
