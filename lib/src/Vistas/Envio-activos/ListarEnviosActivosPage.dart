import 'package:flutter_tags/flutter_tags.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionWidget.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'ListarEnviosActivosController.dart';

class ListarEnviosActivosPage extends StatefulWidget {
  final dynamic objetoModo;
  const ListarEnviosActivosPage({Key key, this.objetoModo}) : super(key: key);

  @override
  _ListarEnviosActivosPageState createState() =>
      _ListarEnviosActivosPageState(objetoModo);
}

class _ListarEnviosActivosPageState extends State<ListarEnviosActivosPage> {
  dynamic objetoModo;
  _ListarEnviosActivosPageState(this.objetoModo);
  EnviosActivosController enviosActivosController =
      new EnviosActivosController();
  List<EstadoEnvio> estadosSave = new List();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<EnvioModel> listEnviosPorRecibir;
  List<EnvioModel> listEnviosEnviados;
  List<EnvioModel> envios = new List();
  List<int> estadosIds = new List();
  bool porRecibir = true;
  List<EstadoEnvio> listEstados = new List();
  int indexSwitch;

  @override
  void initState() {
/*     if (objetoModo == null) {
      indexSwitch = 0;
    } else {
      estadosIds.add(objetoModo["estadoid"]);
      if (objetoModo["modalidad"] == 1) {
      } else {
        indexSwitch = 0;
      }
    } */
    listarEnviosActivos();
    super.initState();
  }

  void notifierAccion(String mensaje, Color color) {
    final snack = new SnackBar(
      content: new Text(mensaje),
      backgroundColor: color,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  void listarEnviosActivos() async {
    listEstados = await enviosActivosController.listarEnviosEstados();
    if (this.mounted) {
      Map country = ModalRoute.of(context).settings.arguments;
      if (country != null) {
        listEstados.forEach((estadoEnvio) {
          if (estadoEnvio.id == country["estadoid"]) {
            estadoEnvio.estado = true;
          } else {
            estadoEnvio.estado = false;
          }
        });
      } else if (objetoModo != null) {
        listEstados.forEach((estadoEnvio) {
          if (estadoEnvio.id == objetoModo["estadoid"]) {
            estadoEnvio.estado = true;
          } else {
            estadoEnvio.estado = false;
          }
        });
      }
      listEnviosPorRecibir =
          await enviosActivosController.listarActivosController(
              porRecibir,
              listEstados
                  .where((envio) => envio.estado)
                  .map((envio) => envio.id)
                  .toList());
      listEnviosEnviados =
          await enviosActivosController.listarActivosController(
              !porRecibir,
              listEstados
                  .where((envio) => envio.estado)
                  .map((envio) => envio.id)
                  .toList());
      setState(() {
        if (country != null) {
          indexSwitch = country["modalidad"];
        } else {
          if (objetoModo != null) {
            indexSwitch = objetoModo["modalidad"];
          } else {
            indexSwitch = 0;
          }
        }
        indexSwitch = indexSwitch;
        listEnviosPorRecibir = listEnviosPorRecibir;
        listEnviosEnviados = listEnviosEnviados;
        listEstados = listEstados;
      });
    }
  }

  void onchangeEnviosActivos(EstadoEnvio estadoEnvioParam) async {
    List<EstadoEnvio> listEstadosActivos =
        listEstados.where((envio) => envio.estado).toList();

    listEstados.forEach((estadoEnvio) {
      if (estadoEnvio.id == estadoEnvioParam.id) {
        listEstadosActivos
            .removeWhere((estadoActivo) => estadoActivo.id == estadoEnvio.id);
        if (listEstadosActivos.isEmpty) {
          notifierAccion("Se debe tener un estado activo como mínimo",
              StylesThemeData.ERROR_COLOR);
        } else {
          estadoEnvio.estado = !estadoEnvio.estado;
        }
      }
    });

    listEnviosPorRecibir =
        await enviosActivosController.listarActivosController(
            porRecibir,
            listEstados
                .where((envio) => envio.estado)
                .map((envio) => envio.id)
                .toList());
    listEnviosEnviados = await enviosActivosController.listarActivosController(
        !porRecibir,
        listEstados
            .where((envio) => envio.estado)
            .map((envio) => envio.id)
            .toList());

    if (this.mounted) {
      setState(() {
        listEnviosPorRecibir = listEnviosPorRecibir;
        listEnviosEnviados = listEnviosEnviados;
        listEstados = listEstados;
      });
    }
  }

  void onPressedPopUPRecibidos(dynamic indice) {
    trackingPopUp(context, listEnviosPorRecibir[indice].id);
  }

  void onPressedPopUPEnviados(dynamic indice) {
    trackingPopUp(context, listEnviosEnviados[indice].id);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemRecepcion(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        itemIndice: indice,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: "${listEnviosPorRecibir[indice].destinatario}",
        subSecondtitulo: listEnviosPorRecibir[indice].codigoPaquete,
        subThirdtitulo: listEnviosPorRecibir[indice].fecha,
        subFivetitulo: listEnviosPorRecibir[indice].observacion,
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
        onPressedCode: onPressedPopUPRecibidos,
        iconColor: StylesThemeData.ICON_COLOR,
      );
    }

    Widget itemEnviados(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        itemIndice: indice,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR,
        titulo: listEnviosEnviados[indice].destinatario,
        subSecondtitulo: listEnviosEnviados[indice].codigoPaquete,
        subThirdtitulo: listEnviosEnviados[indice].fecha,
        subFivetitulo: listEnviosEnviados[indice].observacion,
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
        onPressedCode: onPressedPopUPEnviados,
        iconColor: StylesThemeData.ICON_COLOR,
      );
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
/*           paddingWidget(Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: FilaButtonWidget(
                firsButton: ButtonWidget(
                    onPressed: onPressedButon,
                    colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                    texto: "Estado")),
          )), */
          Container(
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              child: Tags(
                itemCount: listEstados.length,
                horizontalScroll: true,
                itemBuilder: (int index) {
                  return Tooltip(
                      message: listEstados[index].nombre,
                      child: Container(
                        width: 120,
                        child: ItemTags(
                          border: Border.all(
                              width: 0,
                              color: listEstados[index].estado
                                  ? StylesThemeData.BUTTON_PRIMARY_COLOR
                                  : StylesThemeData.BUTTON_DISABLE_COLOR),
                          title: listEstados[index].nombre,
                          active: true,
                          activeColor: listEstados[index].estado
                              ? StylesThemeData.BUTTON_PRIMARY_COLOR
                              : StylesThemeData.BUTTON_DISABLE_COLOR,
                          color: listEstados[index].estado
                              ? StylesThemeData.BUTTON_PRIMARY_COLOR
                              : StylesThemeData.BUTTON_DISABLE_COLOR,
                          pressEnabled: true,
                          textActiveColor: Colors.white,
                          textOverflow: TextOverflow.ellipsis,
                          textColor: Colors.white,
                          onPressed: (item) {
                            onchangeEnviosActivos(listEstados[index]);
                          },
                          textStyle: TextStyle(fontSize: 13),
                          key: Key(index.toString()),
                          index: index,
                        ),
                      ));
                },
              )),
          Expanded(
              child: Container(
            child: TabSectionWidget(
              iconPrimerTap: IconsData.ICON_POR_RECIBIR,
              iconSecondTap: IconsData.ICON_ENVIADOS,
              namePrimerTap: "Por recibir",
              nameSecondTap: "Enviados",
              listPrimerTap: listEnviosPorRecibir,
              listSecondTap: listEnviosEnviados,
              itemPrimerTapWidget: itemRecepcion,
              itemSecondTapWidget: itemEnviados,
              initstateIndex: indexSwitch,
            ),
            margin: const EdgeInsets.only(bottom: 5),
          ))
        ],
      );
    }

    return Scaffold(
        key: scaffoldkey,
        appBar: CustomAppBar(
          text: "Envios activos",
          leadingbool: boolIfPerfil() ? false : true,
        ),
        drawer: drawerIfPerfil(),
        body: mainscaffold());
  }
}
