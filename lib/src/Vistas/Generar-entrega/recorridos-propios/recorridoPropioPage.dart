import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/recorridos-propios/recorridoPropioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';

class RecorridosPropiosPage extends StatefulWidget {
  @override
  _RecorridosPropiosPageState createState() => _RecorridosPropiosPageState();
}

class _RecorridosPropiosPageState extends State<RecorridosPropiosPage> {
  RecorridoPropioController principalcontroller =
      new RecorridoPropioController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();

  var listadestinatarios;
  String textdestinatario = "";

  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;

  var nuevo = 0;

  @override
  void initState() {
    //listadetinatario= principalcontroller.ListarDestinario();
    prueba = Text("Usuarios frecuentes",
        style: TextStyle(fontSize: 15, color: Color(0xFFACADAD)));

    setState(() {
      //listadetinatario =principalcontroller.ListarDestinario();
      //listadetinatarioDisplay = listadetinatario;

      /* */

      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);
    var booleancolor = true;
    var colorwidget = colorplomo;

    Widget informacionEntrega(RecorridoModel envio) {
      String recorrido = envio.nombre;
      String horario = envio.horaInicio + " - " + envio.horaFin;
      String usuario = envio.usuario;

      return Container(
          height: 100,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              height: 20,
              child: ListTile(title: Text("$recorrido")),
            ),
            Container(
                height: 20,
                child: ListTile(
                    title: Text("$horario", style: TextStyle(fontSize: 11)))),
            Container(
                height: 20,
                child: ListTile(
                  title: Text("$usuario"),
                  leading: Icon(
                    Icons.perm_identity,
                    color: Color(0xffC7C7C7),
                  ),
                )),
          ]));
    }

    Widget crearItem(RecorridoModel entrega) {
      //String nombrearea = usuario.area;
      //String nombresede = usuario.sede;
      if (booleancolor) {
        colorwidget = colorplomo;
        booleancolor = false;
      } else {
        colorwidget = colorblanco;
        booleancolor = true;
      }
      return Container(
        decoration: myBoxDecoration(),
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: informacionEntrega(entrega),
                flex: 5,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            child: IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    color: Color(0xffC7C7C7), size: 50),
                                onPressed: _onSearchButtonPresseds))
                      ])),
            ]),
      );
    }

    Widget crearItemVacio() {
      return Container();
    }

    Widget _crearListado() {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.listarentregasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
              final recorridos = snapshot.data;
              return ListView.builder(
                  itemCount: recorridos.length,
                  itemBuilder: (context, i) => crearItem(recorridos[i]));
            } else {
              return Container();
            }
          });
    }

    //final subtitulo = Text('Elige el recorrido', style: TextStyle(color: colorletra));

    final subtitulo =
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      Expanded(
        child: Text('Elige el recorrido', style: TextStyle(color: colorletra)),
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
    ]);

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
          title: Text('Nueva entrega en sede',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 6),
                    width: double.infinity,
                    child: subtitulo),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter, child: _crearListado()),
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

  void _onSearchButtonPressed() {
    Navigator.of(context).pushNamed('/entregas-pisos-adicionales');
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  void _onSearchButtonPresseds() {}
}
