import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaPersonalizadaEnum.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-DNI/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-firma/Generar-Firma/GenerarFirmaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';
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
                  paddingWidget(
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 20),
                    child: Text(
                      "Escoger un tipo de entrega",
                      style: TextStyle(
                          fontSize: 15, color: StylesThemeData.LETTER_COLOR),
                    ),
                  )
                  ),
                  Container(child: _crearListaTipoPaquete())
                ],
              ),
            ),
            context));
  }

  Widget _crearListaTipoPaquete() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
            future:
                paqueteExternoController.listarTiposEntregasPersonalizadas(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TipoEntregaPersonalizadaModel>> snapshot) {
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
                      listTipoEntrega = snapshot.data;
                      if (listTipoEntrega.length == 0) {
                        return sinResultados("No se han encontrado resultados",
                            IconsData.ICON_ERROR_EMPTY);
                      } else {
                        return ListView.builder(
                            itemCount: listTipoEntrega.length,
                            itemBuilder: (context, i) => ItemWidget(
                                iconPrimary: IconsData.ICON_USER,
                                iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
                                itemIndice: i,
                                methodAction: _onSearchButtonPressed,
                                colorItem: i % 2 == 0
                                    ? StylesThemeData.ITEM_SHADED_COLOR
                                    : StylesThemeData.ITEM_UNSHADED_COLOR,
                                titulo: listTipoEntrega[i].descripcion,
                                subtitulo: null,
                                subSecondtitulo: null,
                                styleTitulo: StylesTitleData.STYLE_TITLE,
                                styleSubTitulo: null,
                                styleSubSecondtitulo: null,
                                iconColor: StylesThemeData.ICON_COLOR));
                      }
                    } else {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    }
                  }
              }
            }),
      ),
    );
  }
}
