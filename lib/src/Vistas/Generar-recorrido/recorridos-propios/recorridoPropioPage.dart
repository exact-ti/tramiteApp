import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-propios/recorridoPropioController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

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
/*     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ValidacionEnvioPage(recorridopage: listRecorridos[indiceRecorrido]),
      ),
    ); */
    Navigator.of(context).pushNamed(
      '/entregas-pisos-validacion',
      arguments: {
        'recorridoId': listRecorridos[indiceRecorrido].id,
      },
    );
  }

  setList(List<dynamic> listRecorridos) {
    this.listRecorridos = listRecorridos;
  }

  @override
  Widget build(BuildContext context) {
    Widget itemWidget(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          iconPrimary: IconsData.ICON_USER,
          iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
          itemIndice: indice,
          methodAction: onPressRecorrido,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listRecorridos[indice].nombre,
          subtitulo: listRecorridos[indice].usuario,
          subSecondtitulo:
              "${listRecorridos[indice].horaInicio} - ${listRecorridos[indice].horaFin}",
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
          iconColor: StylesThemeData.ICON_COLOR);
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
                FutureItemWidget(
                    itemWidget: itemWidget,
                    setList: setList,
                    futureList:
                        principalcontroller.listarRecorridosController())
              ],
            ),
            context));
  }
}
