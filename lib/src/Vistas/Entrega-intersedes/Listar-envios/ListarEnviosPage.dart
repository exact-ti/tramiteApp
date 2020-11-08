import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionWidget2.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'ListarEnviosController.dart';

class ListarEnviosPage extends StatefulWidget {
  @override
  _ListarEnviosPageState createState() => _ListarEnviosPageState();
}

class _ListarEnviosPageState extends State<ListarEnviosPage> {
  ListarEnviosController listarEnviosController = new ListarEnviosController();
  List<EnvioInterSedeModel> listEnviosPorRecibir;
  List<EnvioInterSedeModel> listEnviosEnviados;
  bool porRecibir = true;
  List<bool> isSelected;
  int indexSwitch = 0;

  @override
  void initState() {
    isSelected = [true, false];
    listarEnviosIntersedes();
    super.initState();
  }

  void listarEnviosIntersedes() async {
    listEnviosPorRecibir = await listarEnviosController
        .listarentregasInterSedeController(porRecibir);
    listEnviosEnviados = await listarEnviosController
        .listarentregasInterSedeController(!porRecibir);
    if (this.mounted) {
      setState(() {
        listEnviosPorRecibir = listEnviosPorRecibir;
        listEnviosEnviados = listEnviosEnviados;
      });
    }
  }

  void iniciarEnvio(dynamic intersedeIndice) async {
    if (listEnviosEnviados[intersedeIndice].estadoEnvio.id == creado) {
      bool respuesta = await listarEnviosController.onSearchButtonPressed(
          context, listEnviosEnviados[intersedeIndice]);
      if (respuesta) {
        notificacion(context, "success", "EXACT",
            "Se ha iniciado el envío correctamente");
        listarEnviosIntersedes();
      } else {
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }
  }

  String obtenerTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].destino;
  }

  String obtenerSubTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].codigo;
  }

  String obtenerSecondSubTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].numdocumentos == 1
        ? "${listEnviosPorRecibir[intersedeIndice].numdocumentos} envío"
        : "${listEnviosPorRecibir[intersedeIndice].numdocumentos} envíos";
  }

  String obtenerTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].destino;
  }

  String obtenerSubTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].numvalijas == 1
        ? "${listEnviosEnviados[intersedeIndice].numvalijas} valija"
        : "${listEnviosEnviados[intersedeIndice].numvalijas} valijas";
  }

  String obtenerSecondSubTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].numdocumentos == 1
        ? "${listEnviosEnviados[intersedeIndice].numdocumentos} envío"
        : "${listEnviosEnviados[intersedeIndice].numdocumentos} envíos";
  }

  void actionButtonNuevo() {
    Navigator.of(context).pushNamed('/nueva-entrega-intersede');
  }

  void actionButtonRecepcionar() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionInterPage(recorridopage: null),
        )).whenComplete(listarEnviosIntersedes);
  }

  void recepcionarEnvio(dynamic intersedeIndice) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionInterPage(
              recorridopage: listEnviosPorRecibir[intersedeIndice]),
        )).whenComplete(listarEnviosIntersedes);
  }

  IconData obtenerIconInRecepciones(dynamic intersedeIndice) {
    return FontAwesomeIcons.locationArrow;
  }

  IconData obtenerIconInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].estadoEnvio.id == creado
        ? FontAwesomeIcons.locationArrow
        : null;
  }

  Widget itemRecepcion(dynamic indice) {
    return ItemWidget(
      itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
      itemIndice: indice,
      iconPrimary: FontAwesomeIcons.cube,
      iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
      iconColor: StylesThemeData.ICON_COLOR,
      methodAction: recepcionarEnvio,
      colorItem: indice % 2 == 0
          ? StylesThemeData.ITEM_SHADED_COLOR
          : StylesThemeData.ITEM_UNSHADED_COLOR,
      titulo: "${listEnviosPorRecibir[indice].destino}",
      subtitulo: "${listEnviosPorRecibir[indice].codigo}",
      subSecondtitulo: listEnviosPorRecibir[indice].numdocumentos == 1
          ? "${listEnviosPorRecibir[indice].numdocumentos} envío"
          : "${listEnviosPorRecibir[indice].numdocumentos} envíos",
      styleTitulo: StylesTitleData.STYLE_TITLE,
      styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
    );
  }

  Widget itemEnviados(dynamic indice) {
    return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
        itemIndice: indice,
        iconPrimary: FontAwesomeIcons.cube,
        methodAction: iniciarEnvio,
        iconSend: listEnviosEnviados[indice].estadoEnvio.id == creado
            ? IconsData.ICON_ITEM_WIDGETRIGHT
            : null,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: "${listEnviosEnviados[indice].destino}",
        subtitulo: listEnviosEnviados[indice].numvalijas == 1
            ? "${listEnviosEnviados[indice].numvalijas} valija"
            : "${listEnviosEnviados[indice].numvalijas} valijas",
        subSecondtitulo: listEnviosEnviados[indice].numdocumentos == 1
            ? "${listEnviosEnviados[indice].numdocumentos} envío"
            : "${listEnviosEnviados[indice].numdocumentos} envíos",
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
        iconColor: StylesThemeData.ICON_COLOR);
  }

  @override
  Widget build(BuildContext context) {
    Widget filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: ButtonWidget(
                  iconoButton: IconsData.ICON_NEW,
                  onPressed: actionButtonNuevo,
                  colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                  texto: "Nuevo")),
          Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: ButtonWidget(
                      iconoButton: IconsData.ICON_RECEIVE,
                      onPressed: actionButtonRecepcionar,
                      colorParam: StylesThemeData.BUTTON_SECUNDARY_COLOR,
                      texto: "Recepcionar"))),
        ],
      ),
    );
    return Scaffold(
        appBar: CustomAppBar(text: "Entregas interUTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[filaBotones],
                    ))),
                Expanded(
                    child: TabSectionWidget2(
                  iconPrimerTap: IconsData.ICON_POR_RECIBIR,
                  iconSecondTap: IconsData.ICON_ENVIADOS,
                  namePrimerTap: "Por recibir",
                  nameSecondTap: "Enviados",
                  listPrimerTap: listEnviosPorRecibir,
                  listSecondTap: listEnviosEnviados,
                  itemPrimerTapWidget: itemRecepcion,
                  itemSecondTapWidget: itemEnviados,
                ))
              ],
            ),
            context));
  }
}
