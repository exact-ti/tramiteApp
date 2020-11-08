import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaPersonalizadaEnum.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-DNI/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-firma/Generar-Firma/GenerarFirmaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'ListarTipoPersonalizadaController.dart';

class ListarTipoPersonalizadaPage extends StatefulWidget {
  @override
  _ListarTipoPersonalizadaPageState createState() =>
      _ListarTipoPersonalizadaPageState();
}

class _ListarTipoPersonalizadaPageState
    extends State<ListarTipoPersonalizadaPage> {
  ListarTipoPersonalizadaController paqueteExternoController =
      new ListarTipoPersonalizadaController();
  List<TipoEntregaPersonalizadaModel> listTipoEntrega = new List();

  void _onSearchButtonPressed(dynamic indiceTipoEntrega) {
    TipoEntregaPersonalizadaModel item = listTipoEntrega[indiceTipoEntrega];
    if (item.id == dniId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntregapersonalizadoPageDNI(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarFirmaPage(),
        ),
      );
    }
  }

  Widget itemPaqueteWidget(dynamic indice) {
    return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        iconPrimary: IconsData.ICON_USER,
        iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
        itemIndice: indice,
        methodAction: _onSearchButtonPressed,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: listTipoEntrega[indice].descripcion,
        styleTitulo: StylesTitleData.STYLE_TITLE,
        iconColor: StylesThemeData.ICON_COLOR);
  }

  void setList(List<dynamic> listaTipos) {
    this.listTipoEntrega = listaTipos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        backgroundColor: Colors.white,
        body: scaffoldbody(
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  paddingWidget(Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Text(
                      "Escoger un tipo de entrega",
                      style: TextStyle(
                          fontSize: 15, color: StylesThemeData.LETTER_COLOR),
                    ),
                  )),
                  Container(
                      child: FutureItemWidget(
                    itemWidget: itemPaqueteWidget,
                    futureList: paqueteExternoController
                        .listarTiposEntregasPersonalizadas(),
                    setList: setList,
                  ))
                ],
              ),
            ),
            context));
  }
}
