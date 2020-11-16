import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLoteController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionListWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

class ListaEntregaLotePage extends StatefulWidget {
  @override
  _ListaEntregaLotePageState createState() => new _ListaEntregaLotePageState();
}

class _ListaEntregaLotePageState extends State<ListaEntregaLotePage> {
  ListaEntregaLoteController listarLoteController =
      new ListaEntregaLoteController();
  int modalidadTipoId = 0;
  List<EntregaLoteModel> entregas = new List();
  List<EntregaLoteModel> listLotesPorRecibir;
  List<EntregaLoteModel> listLotesPorEnviados;
  bool buttonNuevo = false;
  int indexTabSection = 0;

  @override
  void initState() {
    listarEnviosLotes();
    super.initState();
  }

  void listarEnviosLotes() async {
    listLotesPorRecibir = await listarLoteController.listarLotesPorRecibir();
    listLotesPorEnviados = await listarLoteController.listarLotesActivos();
    if (this.mounted) {
      setState(() {
        this.listLotesPorRecibir = listLotesPorRecibir;
        this.listLotesPorEnviados = listLotesPorEnviados;
      });
    }
  }

  void setValueButton(dynamic indexTab) {
    if (indexTab == 0) {
      setState(() {
        buttonNuevo = false;
      });
    } else {
      setState(() {
        buttonNuevo = true;
      });
    }
  }

  void actionButton() {
    if (!buttonNuevo) {
      Navigator.of(context).pushNamed('/recepcionar-lote', arguments: {
        'codLote': null,
      });
    } else {
      Navigator.of(context).pushNamed('/nuevo-Lote');
    }
  }

  void iniciarEnvioLote(indice) async {
    if(listLotesPorEnviados[indice].estadoEnvio.id==creado){
    bool respuesta = await listarLoteController.onSearchButtonPressed(
        context, listLotesPorEnviados[indice]);
    if (respuesta) {
      notificacion(
          context, "success", "EXACT", "Se ha iniciado el envío correctamente");
      listarEnviosLotes();
      setState(() {
        modalidadTipoId = modalidadTipoId;
      });
    } else {
      notificacion(context, "error", "EXACT", "No se pudo iniciar la entrega");
    }
    }else{
      notificacion(context, "error", "EXACT", "El envío ya se ha enviado");

    }

  }

  void methodRecepcionarLote(indice) {
    Navigator.of(context).pushNamed('/recepcionar-lote', arguments: {
      'codLote': listLotesPorRecibir[indice].paqueteId,
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget itemLotesEnviados(dynamic indice) {
      String tituloItem = listLotesPorEnviados[indice].cantLotes == 1 ? "${listLotesPorEnviados[indice].udtNombre} (${listLotesPorEnviados[indice].cantLotes} lote)":"${listLotesPorEnviados[indice].udtNombre} (${listLotesPorEnviados[indice].cantLotes} lotes)";
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
          itemIndice: indice,
          iconPrimary: IconsData.ICON_LOTE_VALIJA,
          iconSend: listLotesPorEnviados[indice].estadoEnvio.id == creado
              ? IconsData.ICON_ITEM_WIDGETRIGHT
              : null,
          methodAction: iniciarEnvioLote,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: tituloItem,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    Widget itemLotesRecepcion(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          itemIndice: indice,
          iconPrimary: IconsData.ICON_LOTE_VALIJA,
          methodAction: methodRecepcionarLote,
          iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: "${listLotesPorRecibir[indice].udtNombre}",
          subtitulo: listLotesPorRecibir[indice].paqueteId,
          subSecondtitulo: listLotesPorRecibir[indice].cantLotes == 1
              ? "${listLotesPorRecibir[indice].cantLotes} valija"
              : "${listLotesPorRecibir[indice].cantLotes} valijas",
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    return Scaffold(
      appBar: CustomAppBar(text: 'Entregas de Lotes'),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                width: double.infinity,
                child: FilaButtonWidget(
                  firsButton: ButtonWidget(
                      iconoButton: !buttonNuevo
                          ? IconsData.ICON_RECEIVE
                          : IconsData.ICON_NEW,
                      onPressed: actionButton,
                      colorParam: !buttonNuevo
                          ? StylesThemeData.DISABLE_COLOR
                          : StylesThemeData.PRIMARY_COLOR,
                      texto: !buttonNuevo ? 'Recepcionar' : 'Nuevo'),
                )),
          ),
          Expanded(
              child: TabSectionListWidget(
            iconPrimerTap: IconsData.ICON_POR_RECIBIR,
            iconSecondTap: IconsData.ICON_ENVIADOS,
            namePrimerTap: "Por recibir",
            nameSecondTap: "Enviados",
            listPrimerTap: listLotesPorRecibir,
            listSecondTap: listLotesPorEnviados,
            itemPrimerTapWidget: itemLotesRecepcion,
            itemSecondTapWidget: itemLotesEnviados,
            onTapTabSection: setValueButton,
            initstateIndex: indexTabSection,
          ))
        ],
      ),
    );
  }
}
