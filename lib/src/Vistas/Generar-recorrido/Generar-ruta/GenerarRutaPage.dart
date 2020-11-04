import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Detalle-ruta/DetalleRutaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
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
          alignment: Alignment.center,
          height: 80,
          child: Text(
            "$nombre",
            style: TextStyle(fontSize: 11),
          ));
    }

    Widget informacionIcono(String nombre) {
      return Container(
          alignment: Alignment.centerRight,
          height: 80,
          child: Icon(Icons.location_on));
    }

    Widget informacionRecojo(RutaModel ruta) {
      return Container(
          alignment: Alignment.center,
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomCenter,
              height: 40,
              child: Text("Para recoger", style: TextStyle(fontSize: 9)),
            ),
            Center(
              child: Container(
                  height: 40,
                  child: Text("${ruta.cantidadRecojo}",
                      style: TextStyle(fontSize: 11))),
            )
          ]));
    }

    Widget informacionEntrega(RutaModel ruta) {
      return Container(
          height: 80,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 5),
                height: 40,
                child: Text("Para Entrega", style: TextStyle(fontSize: 9)),
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

    Widget crearItem(RutaModel ruta, int indiceItem, Color colorItem) {
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
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorItem,
              border: indiceItem == 0
                  ? Border(
                      top: BorderSide(
                          width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                      bottom: BorderSide(
                          width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                    )
                  : Border(
                      bottom: BorderSide(
                          width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                    ),
            ),
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
                return sinResultados("No hay conexión con el servidor",
                    IconsData.ICON_ERROR_SERVIDOR);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados(
                      "Ha surgido un problema", IconsData.ICON_ERROR_PROBLEM);
                } else {
                  if (snapshot.hasData) {
                    final rutas = snapshot.data;
                    if (rutas.length == 0) {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      this.cantidad = rutas.length;
                      return ListView.builder(
                          itemCount: rutas.length,
                          itemBuilder: (context, i) => crearItem(
                              rutas[i],
                              i,
                              i % 2 == 0
                                  ? StylesThemeData.ITEM_SHADED_COLOR
                                  : StylesThemeData.ITEM_UNSHADED_COLOR));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados",
                        IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    Widget filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ButtonWidget(
                onPressed: onPresBack,
                colorParam: StylesThemeData.BUTTON_SECUNDARY_COLOR,
                texto: recorridoUsuario.indicepagina == 1
                    ? "Empezar recorrido"
                    : "Retroceder"),
            flex: 5,
          ),
          Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: ButtonWidget(
                      onPressed: actionButton,
                      colorParam: StylesThemeData.PRIMARY_COLOR,
                      texto: recorridoUsuario.indicepagina == 1
                          ? 'Empezar recorrido'
                          : 'Terminar')))
        ],
      ),
    );

    return Scaffold(
        appBar: CustomAppBar(text: "Consultas"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    width: double.infinity,
                    child: Text("Tu ruta",
                        style: TextStyle(
                            fontSize: 20,
                            color: StylesThemeData.LETTER_COLOR)))),
                Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: _crearListado()),
                ),
                paddingWidget(Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    width: double.infinity,
                    child: recorridoUsuario.indicepagina != 1
                        ? filaBotones
                        : ButtonWidget(
                            onPressed: actionButton,
                            colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                            texto: recorridoUsuario.indicepagina == 1
                                ? 'Empezar recorrido'
                                : 'Terminar'))),
              ],
            ),
            context));
  }
}
