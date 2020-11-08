import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionWidget2.dart';
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
  List<EnvioModel> listEnviosPorRecibir;
  List<EnvioModel> listEnviosEnviados;
  List<EnvioModel> envios = new List();
  List<int> estadosIds = new List();
  List<bool> isSelected;
  bool porRecibir = true;

  int indexSwitch = 0;

  @override
  void initState() {
    isSelected = [true, false];
    if (objetoModo == null) {
      estadosIds = [];
      isSelected = [true, false];
      indexSwitch = 0;
    } else {
      estadosIds.add(objetoModo["estadoid"]);
      if (objetoModo["modalidad"] == 1) {
        isSelected = [false, true];
        indexSwitch = 1;
      } else {
        isSelected = [true, false];
        indexSwitch = 0;
      }
    }
    listarEnviosIntersedes();
    super.initState();
  }

  void listarEnviosIntersedes() async {
    listEnviosPorRecibir = await enviosActivosController
        .listarActivosController(porRecibir, estadosIds);
    listEnviosEnviados = await enviosActivosController.listarActivosController(
        !porRecibir, estadosIds);
    if (this.mounted) {
      setState(() {
        listEnviosPorRecibir = listEnviosPorRecibir;
        listEnviosEnviados = listEnviosEnviados;
      });
    }
  }

  String obtenerTituloInRecibidos(dynamic indice) {
    return listEnviosPorRecibir[indice].destinatario;
  }

  String obtenerSubSecondTituloInRecibidos(dynamic indice) {
    return listEnviosPorRecibir[indice].codigoPaquete;
  }

  String obtenerSubThirdTituloInRecibidos(dynamic indice) {
    return listEnviosPorRecibir[indice].fecha;
  }

  String obtenerSubFiveTituloInRecibidos(dynamic indice) {
    return listEnviosPorRecibir[indice].observacion;
  }

  String obtenerTituloInEnviados(dynamic indice) {
    return listEnviosEnviados[indice].destinatario;
  }

  String obtenerSubSecondTituloInEnviados(dynamic indice) {
    return listEnviosEnviados[indice].codigoPaquete;
  }

  String obtenerSubThirdTituloInEnviados(dynamic indice) {
    return listEnviosEnviados[indice].fecha;
  }

  String obtenerSubFiveTituloInEnviados(dynamic indice) {
    return listEnviosEnviados[indice].observacion;
  }

  void onPressedPopUPRecibidos(dynamic indice) {
    trackingPopUp(context, listEnviosPorRecibir[indice].id);
  }

  void onPressedPopUPEnviados(dynamic indice) {
    trackingPopUp(context, listEnviosEnviados[indice].id);
  }

  @override
  Widget build(BuildContext context) {
    Widget listTagSave(List<int> idsparam) {
      List<EstadoEnvio> listaparam = new List();
      listaparam = estadosSave
          .where((element) => idsparam.contains(element.id))
          .toList();
      return Container(
          child: Tags(
        itemCount: listaparam.length,
        itemBuilder: (int index) {
          return Tooltip(
              message: listaparam[index].nombre,
              child: ItemTags(
                title: listaparam[index].nombre,
                pressEnabled: false,
                textStyle: TextStyle(fontSize: 13),
                key: Key(index.toString()),
                index: index,
              ));
        },
      ));
    }

    Widget listTagFuture(List<int> estadosParam) {
      return FutureBuilder(
          future: enviosActivosController.listarEnviosEstados(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EstadoEnvio>> snapshot) {
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
                    estadosSave = snapshot.data;
                    if (estadosSave.length != 0) {
                      List<EstadoEnvio> listaparam = new List();
                      if (objetoModo != null) {
                        estadosSave.forEach((element) {
                          if (element.id == objetoModo["estadoid"]) {
                            listaparam.add(element);
                            element.estado = true;
                          } else {
                            element.estado = false;
                          }
                        });
                      } else {
                        estadosSave.forEach((element) {
                          listaparam.add(element);
                          element.estado = true;
                        });
                      }

                      return Container(
                          child: Tags(
                        itemCount: listaparam.length,
                        itemBuilder: (int index) {
                          return Tooltip(
                              message: listaparam[index].nombre,
                              child: ItemTags(
                                title: listaparam[index].nombre,
                                pressEnabled: false,
                                textStyle: TextStyle(fontSize: 13),
                                key: Key(index.toString()),
                                index: index,
                              ));
                        },
                      ));
                    } else {
                      return Container();
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados",
                        IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    Widget listarTags(
        List<EstadoEnvio> estadosparam, List<int> estadosidsparam) {
      if (estadosparam.length == 0) {
        return listTagFuture(estadosidsparam);
      } else {
        return listTagSave(estadosidsparam);
      }
    }

    Future<List<int>> popupEstados(
        BuildContext context, String titulo, List<int> idsestado) async {
      List<int> listarids = new List();
      if (idsestado.length == 0) {
        estadosSave.forEach((element) {
          element.estado = true;
        });
      } else {
        estadosSave.forEach((element) {
          if (idsestado.contains(element.id)) {
            element.estado = true;
          } else {
            element.estado = false;
          }
        });
      }
      bool respuesta = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                  alignment: Alignment.centerLeft,
                  height: 60.00,
                  width: double.infinity,
                  child: Container(
                      child: Text('$titulo',
                          style: TextStyle(color: Colors.blue[200])),
                      margin: const EdgeInsets.only(left: 20)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 3.0, color: Colors.blue[200]),
                    ),
                  )),
              content: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Container(
                          child: Text("Seleccionar estados"),
                          margin: const EdgeInsets.only(bottom: 10)),
                      ListBody(
                          children: estadosSave.map((estado) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return new CheckboxListTile(
                              title: new Text(estado.nombre),
                              value: estado.estado,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool value) {
                                setState(() {
                                  estado.estado = value;
                                });
                              });
                        });
                      }).toList())
                    ]),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () => estadosSave
                                      .where(
                                          (element) => element.estado == true)
                                      .length !=
                                  0
                              ? Navigator.pop(context, true)
                              : null,
                          child: Center(
                              child: Container(
                                  height: 50.00,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: 3.0,
                                            color: Colors.grey[100]),
                                        right: BorderSide(
                                            width: 1.5,
                                            color: Colors.grey[100])),
                                  ),
                                  child: Container(
                                    child: Text('Confirmar',
                                        style: TextStyle(color: Colors.black)),
                                  ))),
                        ),
                        flex: 5,
                      ),
                      Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () => Navigator.pop(context, false),
                            child: Center(
                                child: Container(
                                    height: 50.00,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 3.0,
                                              color: Colors.grey[100]),
                                          left: BorderSide(
                                              width: 1.5,
                                              color: Colors.grey[100])),
                                    ),
                                    child: Container(
                                      child: Text('Cancelar',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ))),
                          ))
                    ],
                  )
                ]),
              ),
              contentPadding: EdgeInsets.all(0),
            );
          });

      if (respuesta == null || !respuesta) {
        return idsestado;
      } else {
        estadosSave.forEach((element) {
          if (element.estado) {
            listarids.add(element.id);
          }
        });
        return listarids;
      }
    }

    void onPressedButon() async {
      estadosIds = await popupEstados(context, "EXACT", estadosIds);
      setState(() {
        estadosIds = estadosIds;
      });
    }

    Widget itemRecepcion(dynamic indice) {
      return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
        itemIndice: indice,
        iconPrimary: FontAwesomeIcons.cube,
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
        iconPrimary: FontAwesomeIcons.cube,
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
          paddingWidget(Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: FilaButtonWidget(
                firsButton: ButtonWidget(
                    onPressed: onPressedButon,
                    colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                    texto: "Estado")),
          )),
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              width: double.infinity,
              child: listarTags(estadosSave, estadosIds)),
          Expanded(
              child: Container(
            child: TabSectionWidget2(
              iconPrimerTap: IconsData.ICON_POR_RECIBIR,
              iconSecondTap: IconsData.ICON_ENVIADOS,
              namePrimerTap: "Por recibir",
              nameSecondTap: "Enviados",
              listPrimerTap: listEnviosPorRecibir,
              listSecondTap: listEnviosEnviados,
              itemPrimerTapWidget: itemRecepcion,
              itemSecondTapWidget: itemEnviados,

            ),
            margin: const EdgeInsets.only(bottom: 5),
          ))
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          text: "Envios activos",
          leadingbool: boolIfPerfil() ? false : true,
        ),
        drawer: drawerIfPerfil(),
        body: mainscaffold());
  }
}
