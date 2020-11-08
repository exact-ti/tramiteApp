import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLoteController.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Nueva-entrega-lote/NuevaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionWidget2.dart';
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
  List<bool> isSelected;
  int modalidadTipoId = 0;
  List<EntregaLoteModel> entregas = new List();
  List<EntregaLoteModel> listLotesPorRecibir;
  List<EntregaLoteModel> listLotesPorEnviados;

  @override
  void initState() {
    isSelected = [true, false];
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

  void onPressedRecepcionarButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionEntregaLotePage(entregaLotepage: null),
        ));
  }

  void onPressedNuevoButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoEntregaLotePage(),
      ),
    );
  }

  void iniciarEnvioLote(indice) async {
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
  }

  void methodRecepcionarLote(indice) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionEntregaLotePage(
              entregaLotepage: listLotesPorRecibir[indice]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    
    Widget itemLotesEnviados(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
        itemIndice: indice,
        iconPrimary: FontAwesomeIcons.cube,
        iconSend: listLotesPorEnviados[indice].estadoEnvio.id == creado
            ? IconsData.ICON_ITEM_WIDGETRIGHT
            : null,
        methodAction: iniciarEnvioLote,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: "${listLotesPorEnviados[indice].udtNombre}",
        subtitulo: listLotesPorEnviados[indice].cantLotes == 1
            ? "${listLotesPorEnviados[indice].cantLotes} lote"
            : "${listLotesPorEnviados[indice].cantLotes} lotes",
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
                iconColor: StylesThemeData.ICON_COLOR

      );
    }

    Widget itemLotesRecepcion(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
        itemIndice: indice,
        iconPrimary: FontAwesomeIcons.cube,
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
        iconColor: StylesThemeData.ICON_COLOR
      );
    }

    return Scaffold(
      appBar: CustomAppBar(text: 'Entregas de Lotes'),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                width: double.infinity,
                child: FilaButtonWidget(
                  firsButton: ButtonWidget(
                      iconoButton: IconsData.ICON_NEW,
                      onPressed: onPressedNuevoButton,
                      colorParam: StylesThemeData.PRIMARY_COLOR,
                      texto: 'Nuevo'),
                  secondButton: ButtonWidget(
                      iconoButton: IconsData.ICON_RECEIVE,
                      onPressed: onPressedRecepcionarButton,
                      colorParam: StylesThemeData.DISABLE_COLOR,
                      texto: 'Recepcionar'),
                )),
            Expanded(
                child: TabSectionWidget2(
              iconPrimerTap: IconsData.ICON_POR_RECIBIR,
              iconSecondTap: IconsData.ICON_ENVIADOS,
              namePrimerTap: "Por recibir",
              nameSecondTap: "Enviados",
              listPrimerTap: listLotesPorRecibir,
              listSecondTap: listLotesPorEnviados,
              itemPrimerTapWidget: itemLotesRecepcion,
              itemSecondTapWidget: itemLotesEnviados,
            ))
          ],
        ),
      ),
    );
  }
}
