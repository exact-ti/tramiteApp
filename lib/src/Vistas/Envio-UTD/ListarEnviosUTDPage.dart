import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'ListarEnviosUTDController.dart';

class ListarEnviosUTDPage extends StatefulWidget {
  @override
  _ListarEnviosUTDPageState createState() => _ListarEnviosUTDPageState();
}

class _ListarEnviosUTDPageState extends State<ListarEnviosUTDPage> {
  EnviosUTDController principalcontroller = new EnviosUTDController();
  List<EnvioModel> envios = new List();
  @override
  void initState() {
    super.initState();
  }

  
    void setList(List<dynamic> listEnvios) {
      this.envios = listEnvios;
    }


  @override
  Widget build(BuildContext context) {
    void onPressedCodePaquete(dynamic indice) {
      trackingPopUp(context, this.envios[indice].id);
    }

    Widget itemEnvioUTD(indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        itemIndice: indice,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_UNSHADED_COLOR
            : StylesThemeData.ITEM_SHADED_COLOR,
        titulo: this.envios[indice].destinatario,
        subSecondtitulo: this.envios[indice].codigoPaquete,
        styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
        subFivetitulo: this.envios[indice].observacion,
        onPressedCode: onPressedCodePaquete,
        iconColor: StylesThemeData.ICON_COLOR
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Envíos en UTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FutureItemWidget(
                  itemWidget: itemEnvioUTD,
                  futureList: principalcontroller.listarUTDController(),
                  setList: setList,
                )
              ],
            ),
            context));
  }
}
