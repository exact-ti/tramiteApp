import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
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

  @override
  Widget build(BuildContext context) {

    void onPressedCodePaquete(dynamic indice){
          trackingPopUp(context, this.envios[indice].id);
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarUTDController(),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor",
                    IconsData.ICON_ERROR_EMPTY);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados(
                      "Ha surgido un problema", IconsData.ICON_ERROR_EMPTY);
                } else {
                  if (snapshot.hasData) {
                    this.envios = snapshot.data;
                    if (this.envios.length == 0) {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: this.envios.length,
                          itemBuilder: (context, i) => ItemWidget(
                              itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
                              iconPrimary: null,
                              iconSend: null,
                              itemIndice: i,
                              methodAction: null,
                              colorItem: i % 2 == 0
                                      ? StylesThemeData.ITEM_UNSHADED_COLOR
                                      : StylesThemeData.ITEM_SHADED_COLOR,
                              titulo: this.envios[i].destinatario,
                              subtitulo: null,
                              subSecondtitulo: this.envios[i].codigoPaquete,
                              styleTitulo: null,
                              styleSubTitulo: null,
                              styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
                              subFivetitulo: this.envios[i].observacion,
                              onPressedCode: onPressedCodePaquete,
                              iconColor: null));
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
        appBar: CustomAppBar(text: "Envíos en UTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 5),
                      alignment: Alignment.bottomCenter,
                      child: _crearListado()),
                )
              ],
            ),
            context));
  }
}
