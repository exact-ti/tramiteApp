import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';
import 'ListarTurnosController.dart';

class ListarTurnosPage extends StatefulWidget {
  @override
  _ListarTurnosPageState createState() => _ListarTurnosPageState();
}

class _ListarTurnosPageState extends State<ListarTurnosPage> {
  ListarTurnosController principalcontroller = new ListarTurnosController();
  List<EntregaModel> listasRecorridos = new List();
  @override
  void initState() {
    super.initState();
  }

  void redirectButtom() {
    Navigator.of(context).pushNamed('/entregas-pisos-propios');
  }

  void onPressRecorrido(dynamic indiceRecorrido) {
    principalcontroller.onSearchButtonPressed(
        context, listasRecorridos[indiceRecorrido]);
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarentregasController(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EntregaModel>> snapshot) {
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
                    listasRecorridos = snapshot.data;
                    if (listasRecorridos.length == 0) {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: listasRecorridos.length,
                          itemBuilder: (context, i) => ItemWidget(
                              iconPrimary: IconsData.ICON_USER,
                              iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
                              itemIndice: i,
                              methodAction: onPressRecorrido,
                              colorItem: i % 2 == 0
                                  ? StylesThemeData.ITEM_SHADED_COLOR
                                  : StylesThemeData.ITEM_UNSHADED_COLOR,
                              titulo: listasRecorridos[i].nombreTurno,
                              subtitulo: listasRecorridos[i].usuario,
                              subSecondtitulo:
                                  listasRecorridos[i].estado.nombreEstado,
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

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: ButtonWidget(
                  onPressed: redirectButtom,
                  colorParam: StylesThemeData.PRIMARY_COLOR,
                  texto: "Nuevo Recorrido"))),
          Expanded(
            child: Container(
                alignment: Alignment.bottomCenter, child: _crearListado()),
          )
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
