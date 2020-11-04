import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-propios/recorridoPropioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';

class RecorridosPropiosPage extends StatefulWidget {
  @override
  _RecorridosPropiosPageState createState() => _RecorridosPropiosPageState();
}

class _RecorridosPropiosPageState extends State<RecorridosPropiosPage> {
  RecorridoPropioController principalcontroller =
      new RecorridoPropioController();
  List<RecorridoModel> listRecorridos = new List();
  @override
  void initState() {
    super.initState();
  }

  void _onSearchButtonPressed() {
    Navigator.of(context).pushNamed('/entregas-pisos-adicionales');
  }

  void onPressRecorrido(dynamic indiceRecorrido) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ValidacionEnvioPage(recorridopage: listRecorridos[indiceRecorrido]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarentregasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
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
                    listRecorridos = snapshot.data;
                    if (listRecorridos.length == 0) {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: listRecorridos.length,
                          itemBuilder: (context, i) => ItemWidget(
                              iconPrimary: IconsData.ICON_USER,
                              iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
                              itemIndice: i,
                              methodAction: onPressRecorrido,
                              colorItem: i % 2 == 0
                                  ? StylesThemeData.ITEM_SHADED_COLOR
                                  : StylesThemeData.ITEM_UNSHADED_COLOR,
                              titulo: listRecorridos[i].nombre,
                              subtitulo: listRecorridos[i].usuario,
                              subSecondtitulo:
                                  "${listRecorridos[i].horaInicio} - ${listRecorridos[i].horaFin}",
                              styleTitulo: StylesTitleData.STYLE_TITLE,
                              styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
                              styleSubSecondtitulo:
                                  StylesTitleData.STYLE_SECOND_SUBTILE,
                              iconColor: StylesThemeData.ICON_COLOR));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados",
                        IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos programados"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    width: double.infinity,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text('Elige el recorrido',
                                style: TextStyle(
                                    color: StylesThemeData.LETTER_COLOR)),
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
                        ]))),
                Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: _crearListado()),
                )
              ],
            ),
            context));
  }
}
