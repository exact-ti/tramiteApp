import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Detalle-ruta/DetalleRutaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'GenerarRutaController.dart';

class GenerarRutaPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const GenerarRutaPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _GenerarRutaPageState createState() => _GenerarRutaPageState(recorridopage);
}

class _GenerarRutaPageState extends State<GenerarRutaPage> {
  RecorridoModel recorridoUsuario;
  _GenerarRutaPageState(this.recorridoUsuario);
  GenerarRutaController principalcontroller = new GenerarRutaController();
  int cantidad = 0;

  @override
  void initState() {
    super.initState();
  }

  void onPresBack() {
    Navigator.of(context).pop();
  }

  void actionButton() async {
    if (recorridoUsuario.indicepagina != 1) {
      if (this.cantidad != 0) {
        bool respuestabool = await confirmacion(
            context, "success", "EXACT", "Tienes pendientes ¿Desea Continuar?");
        if (respuestabool) {
          principalcontroller.opcionRecorrido(recorridoUsuario, context);
        }
      } else {
        principalcontroller.opcionRecorrido(recorridoUsuario, context);
      }
    } else {
      principalcontroller.opcionRecorrido(recorridoUsuario, context);
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget informacionArea(String nombre) {
      return Container(
          alignment: Alignment.centerLeft,
          height: 80,
          child: Align(
              child: Text(
                "$nombre",
                style: TextStyle(fontSize: 11),
              ),
              alignment: Alignment(-1.2, 0.0)));
    }

    Widget informacionIcono(String nombre) {
      return Container(
          height: 80, child: Center(child: Icon(Icons.location_on)));
    }

    Widget informacionRecojo(RutaModel ruta) {
      return Container(
          alignment: Alignment.center,
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              child: new Center(
                  child: ListTile(
                      title:Text("Para recoger", style: TextStyle(fontSize: 9)))),
            ),
            Center(
              child: Container(
                  height: 40,
                  child: Text("${ruta.cantidadRecojo}",style: TextStyle(fontSize: 11))),
            )
          ]));
    }

    Widget informacionEntrega(RutaModel ruta) {
      return Container(
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Center(
              child: Container(
                height: 40,
                child: ListTile(
                    title: Text("Para Entrega", style: TextStyle(fontSize: 9))),
              ),
            ),
            Center(
              child: Container(
                  height: 40,
                  child: Text("${ruta.cantidadEntrega}",
                      style: TextStyle(fontSize: 11))),
            )
          ]));
    }

    Widget crearItem(RutaModel ruta) {
      return InkWell(
          onTap: () {
            Map<String, Object> objetoSend = {
              'ruta': ruta,
              'recorridoId': this.recorridoUsuario.id
            };
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleRutaPage(objetoModo: objetoSend),
                ));
          },
          child: Container(
            decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
            margin: EdgeInsets.only(bottom: 5),
            height: 80,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: informacionIcono(ruta.nombre),
                    flex: 2,
                  ),
                  Expanded(
                    child: informacionArea(ruta.nombre),
                    flex: 3,
                  ),
                  Expanded(
                    child: informacionRecojo(ruta),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: informacionEntrega(ruta),
                    ),
                    flex: 3,
                  ),
                ]),
          ));
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarMiRuta(recorridoUsuario.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<RutaModel>> snapshot) {
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
                    final rutas = snapshot.data;
                    if (rutas.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      this.cantidad = rutas.length;
                      return ListView.builder(
                          itemCount: rutas.length,
                          itemBuilder: (context, i) => crearItem(rutas[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    Widget filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomButton(
                onPressed: onPresBack,
                colorParam: Colors.grey,
                texto: recorridoUsuario.indicepagina == 1
                    ? "Empezar recorrido"
                    : "Retroceder"),
            flex: 5,
          ),
          Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child:CustomButton(
                  onPressed: actionButton,
                  colorParam: StylesThemeData.PRIMARYCOLOR,
                  texto: recorridoUsuario.indicepagina == 1
                      ? 'Empezar recorrido'
                      : 'Terminar')))
        ],
      ),
    );

    Widget mainscaffold() {
      return Padding(
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
                  child: Text("Tu ruta",
                      style: TextStyle(
                          fontSize: 20, color: StylesThemeData.LETTERCOLOR))),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter, child: _crearListado()),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  alignment: Alignment.center,
                  height: screenHeightExcludingToolbar(context, dividedBy: 4),
                  width: double.infinity,
                  child: recorridoUsuario.indicepagina != 1
                      ? filaBotones
                      : CustomButton(
                          onPressed: actionButton,
                          colorParam: StylesThemeData.PRIMARYCOLOR,
                          texto: recorridoUsuario.indicepagina == 1
                              ? 'Empezar recorrido'
                              : 'Terminar')),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Consultas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
