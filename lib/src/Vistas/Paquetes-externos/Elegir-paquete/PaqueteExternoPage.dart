import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoController.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoPage.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

class PaqueteExternoPage extends StatefulWidget {
  @override
  _PaqueteExternoPageState createState() => _PaqueteExternoPageState();
}

class _PaqueteExternoPageState extends State<PaqueteExternoPage> {
  PaqueteExternoController paqueteExternoController =
      new PaqueteExternoController();
  List<TipoPaqueteModel> listPaquetes = new List();

  void setList(List<dynamic> listPaquetes) {
    this.listPaquetes = listPaquetes;
  }

  void _selectPaquete(dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImportarArchivoPage(tipoPaqueteModel: this.listPaquetes[item]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget paqueteWidget(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
        iconPrimary: IconsData.ICON_FILE,
        iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
        itemIndice: indice,
        methodAction: _selectPaquete,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: this.listPaquetes[indice].nombre,
        styleTitulo: StylesTitleData.STYLE_TITLE,
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Custodia de documentos externos"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: double.infinity,
                    child: Text('Elige el tipo de paquete',
                        style: TextStyle(color: StylesThemeData.LETTER_COLOR)),
                  ),
                ),
                FutureItemWidget(
                    itemWidget: paqueteWidget,
                    setList: setList,
                    futureList:
                        paqueteExternoController.listarPaquetesPorTipo(false))
              ],
            ),
            context));
  }
}
