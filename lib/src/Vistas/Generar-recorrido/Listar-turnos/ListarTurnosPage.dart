import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
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

  setList(List<dynamic> listRecorridos) {
    this.listasRecorridos = listRecorridos;
  }

  @override
  Widget build(BuildContext context) {
    Widget listWidget(dynamic indice) {
      return ItemWidget(
          iconPrimary: IconsData.ICON_USER,
          iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
          itemIndice: indice,
          methodAction: onPressRecorrido,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listasRecorridos[indice].nombreTurno,
          subtitulo: listasRecorridos[indice].usuario,
          subSecondtitulo: listasRecorridos[indice].estado.nombreEstado,
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              child: FilaButtonWidget(
                firsButton: ButtonWidget(
                    iconoButton: IconsData.ICON_NEW,
                    onPressed: redirectButtom,
                    colorParam: StylesThemeData.PRIMARY_COLOR,
                    texto: "Nuevo"),
              ))),
          FutureItemWidget(
              itemWidget: listWidget,
              setList: setList,
              futureList: principalcontroller.listarRecorridosController())
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recorridos"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
