import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEntregaEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionListWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
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
  bool buttonNuevo = false;
  bool porRecibir = true;
  int indexTabSection = 0;

  @override
  void initState() {
    indexTabSection = 0;
    listarEnviosIntersedes();
    super.initState();
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
    if (listEnviosEnviados[intersedeIndice].estadoEnvio.id == EstadoEntregaEnum.CREADA || listEnviosEnviados[intersedeIndice].estadoEnvio.id == EstadoEntregaEnum.TRANSITO) {
      bool confirmarInicio = await confirmacion(context, "success", "EXACT",
          "¿Desea iniciar el envío de la valija a la UTD ${listEnviosEnviados[intersedeIndice].destino}?");
      if (confirmarInicio) {
        bool respuesta = await listarEnviosController.iniciarEntrega(
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

  void actionButton() {
    if (!buttonNuevo) {
      Navigator.of(context).pushNamed('/recepcionar-valija', arguments: {
        'codValija': null,
      }).whenComplete(listarEnviosIntersedes);
    } else {
      Navigator.of(context).pushNamed('/nueva-entrega-intersede');
    }
  }

  void recepcionarEnvio(dynamic intersedeIndice) {
    Navigator.of(context).pushNamed('/recepcionar-valija', arguments: {
      'codValija': listEnviosPorRecibir[intersedeIndice].codigo,
    }).whenComplete(listarEnviosIntersedes);
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
    String subtituloItem = listEnviosPorRecibir[indice].numdocumentos == 1
        ? "${listEnviosPorRecibir[indice].codigo} (${listEnviosPorRecibir[indice].numdocumentos} envío)"
        : "${listEnviosPorRecibir[indice].codigo} (${listEnviosPorRecibir[indice].numdocumentos} envíos)";
    return ItemWidget(
      itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
      itemIndice: indice,
      iconPrimary: IconsData.ICON_LOTE_VALIJA,
      iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
      iconColor: StylesThemeData.ICON_COLOR,
      methodAction: recepcionarEnvio,
      colorItem: indice % 2 == 0
          ? StylesThemeData.ITEM_SHADED_COLOR
          : StylesThemeData.ITEM_UNSHADED_COLOR,
      titulo: "${listEnviosPorRecibir[indice].destino}",
      subtitulo: subtituloItem,
      styleTitulo: StylesTitleData.STYLE_TITLE,
      styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
    );
  }

  Widget itemEnviados(dynamic indice) {
    String subtituloItem = listEnviosEnviados[indice].numvalijas == 1
        ? listEnviosEnviados[indice].numdocumentos == 1
            ? "${listEnviosEnviados[indice].numvalijas} valija (${listEnviosEnviados[indice].numdocumentos} envío)"
            : "${listEnviosEnviados[indice].numvalijas} valija (${listEnviosEnviados[indice].numdocumentos} envíos)"
        : listEnviosEnviados[indice].numdocumentos == 1
            ? "${listEnviosEnviados[indice].numvalijas} valijas (${listEnviosEnviados[indice].numdocumentos} envío)"
            : "${listEnviosEnviados[indice].numvalijas} valijas (${listEnviosEnviados[indice].numdocumentos} envíos)";
    return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        itemIndice: indice,
        iconPrimary: IconsData.ICON_LOTE_VALIJA,
        methodAction: iniciarEnvio,
        iconSend: listarEnviosController
            .iconByEstadoEntrega(listEnviosEnviados[indice].estadoEnvio.id),
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: "${listEnviosEnviados[indice].destino}",
        subtitulo: subtituloItem,
        subSixtitulo: listEnviosEnviados[indice].estadoEnvio.nombre,
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
        iconColor: StylesThemeData.ICON_COLOR);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FilaButtonWidget(
                        firsButton: ButtonWidget(
                            iconoButton: !buttonNuevo
                                ? IconsData.ICON_RECEIVE
                                : IconsData.ICON_NEW,
                            onPressed: actionButton,
                            colorParam: !buttonNuevo
                                ? StylesThemeData.BUTTON_SECUNDARY_COLOR
                                : StylesThemeData.BUTTON_PRIMARY_COLOR,
                            texto: !buttonNuevo ? "Recepcionar" : "Nuevo")))),
                Expanded(
                    child: TabSectionListWidget(
                  iconPrimerTap: IconsData.ICON_POR_RECIBIR,
                  iconSecondTap: IconsData.ICON_ENVIADOS,
                  namePrimerTap: "Por recibir",
                  nameSecondTap: "Enviados",
                  listPrimerTap: listEnviosPorRecibir,
                  listSecondTap: listEnviosEnviados,
                  itemPrimerTapWidget: itemRecepcion,
                  itemSecondTapWidget: itemEnviados,
                  onTapTabSection: setValueButton,
                  initstateIndex: indexTabSection,
                ))
              ],
            ),
            context));
  }
}
