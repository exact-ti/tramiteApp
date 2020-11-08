import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'RetirarEnvioController.dart';

class RetirarEnvioPage extends StatefulWidget {
  @override
  _RetirarEnvioPageState createState() => new _RetirarEnvioPageState();
}

class _RetirarEnvioPageState extends State<RetirarEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  List<EnvioModel> listaEnvios;
  ConsultaEnvioController principalcontroller = new ConsultaEnvioController();
  bool activo = false;
  bool button = false;
  FocusNode f1paquete = FocusNode();
  FocusNode f2remitente = FocusNode();
  FocusNode f3destinatario = FocusNode();

  void initState() {
    super.initState();
  }

  void listarEnvios(String paquete, String remitente, String destinatario,
      bool opcion) async {
    listaEnvios = await principalcontroller.listarEnvios(
        context, paquete, remitente, destinatario, opcion);
    if (listaEnvios.isNotEmpty) {
      setState(() {
        listaEnvios = listaEnvios;
      });
    } else {
      setState(() {
        listaEnvios = [];
        button = true;
      });
    }
  }

  void buscarEnvios() {
    desenfocarInputfx(context);
    if (_paqueteController.text == "" &&
        _remitenteController.text == "" &&
        _destinatarioController.text == "") {
      notificacion(
          context, "error", "EXACT", "Se debe llenar al menos un campo");
      setState(() {
        button = false;
        listaEnvios = [];
      });
    } else {
      setState(() {
        button = true;
      });
      listarEnvios(_paqueteController.text, _remitenteController.text,
          _destinatarioController.text, activo);
    }
  }

  Future<bool> retirarEnvioController(
      EnvioModel envioModel, String motivo) async {
    dynamic respuesta =
        await principalcontroller.retirarEnvio(envioModel, motivo);
    desenfocarInputfx(context);
    if (respuesta.containsValue("success")) {
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      await notificacion(context, "success", "Exact", "Se retiró el envío");
      return true;
    } else {
      await notificacion(context, "Error", "Exact", respuesta["message"]);
      return false;
    }
  }

  Future _traerdatosescanerPaquete() async {
    _paqueteController.text = await getDataFromCamera(context);
    setState(() {
      _paqueteController.text = _paqueteController.text;
    });
    _validarPaqueteText(_paqueteController.text);
  }

  Future<bool> retirarEnvioModal(BuildContext context, String tipo,
      String title, String description, EnvioModel envioModel) async {
    String mensajeError = "";
    final _observacionController = TextEditingController();
    bool respuesta = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('$title',
                        style: TextStyle(
                            color: tipo == "success"
                                ? Colors.blue[200]
                                : Colors.red[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 3.0,
                        color: tipo == "success"
                            ? Colors.blue[200]
                            : Colors.red[200]),
                  ),
                )),
            content: SingleChildScrollView(child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return new Column(mainAxisSize: MainAxisSize.min, children: <
                  Widget>[
                Container(
                  child: Text(description),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Ingrese el motivo:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                ),
                Container(
                  child: TextFormField(
                    maxLines: 6,
                    controller: _observacionController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFEAEFF2),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xFFEAEFF2),
                          width: 0.0,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) async {
                      if (value.length == 0) {
                        setState(() {
                          mensajeError = "El mótivo del retiro es obligatorio";
                        });
                      } else {
                        bool respuesta = await retirarEnvioController(
                            envioModel, _observacionController.text);
                        if (respuesta) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    onChanged: (text) {
                      if (text.length == 0) {
                        setState(() {
                          mensajeError = "El mótivo del retiro es obligatorio";
                        });
                      } else {
                        setState(() {
                          mensajeError = "";
                        });
                      }
                    },
                  ),
                  padding: const EdgeInsets.only(right: 20, left: 20),
                ),
                mensajeError.length == 0
                    ? Container()
                    : Text(
                        mensajeError,
                        style: TextStyle(color: Colors.red),
                      ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              desenfocarInputfx(context);
                              if (_observacionController.text.length == 0) {
                                setState(() {
                                  mensajeError =
                                      "El mótivo del retiro es obligatorio";
                                });
                              } else {
                                bool respuesta = await retirarEnvioController(
                                    envioModel, _observacionController.text);
                                if (respuesta) {
                                  Navigator.pop(context, true);
                                }
                              }
                            },
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
                                      child: Text('Aceptar',
                                          style: _observacionController
                                                      .text.length ==
                                                  0
                                              ? TextStyle(color: Colors.grey)
                                              : TextStyle(color: Colors.black)),
                                    ))),
                          ),
                          flex: 5,
                        ),
                        Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
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
                    ))
              ]);
            })),
            contentPadding: EdgeInsets.all(0),
          );
        });

    if (respuesta == null) {
      respuesta = false;
    }
    return respuesta;
  }

  void _validarPaqueteText(dynamic valuePaqueteController) async {
    enfocarInputfx(context, f2remitente);
  }

  void _validarRemitenteText(dynamic valueRemitenteController) async {
    enfocarInputfx(context, f3destinatario);
  }

  void _validarDestinatarioText(dynamic valueDestinatarioController) async {
    desenfocarInputfx(context);
  }

  void onPressedCode(dynamic indiceListEnvios) {
    trackingPopUp(context, listaEnvios[indiceListEnvios].id);
  }

  void onPressedWidget(dynamic indiceListEnvios) async {
    bool respuestamodal = await retirarEnvioModal(
        context,
        "success",
        "EXACT",
        "¿Seguro que desea retirar el envío ${listaEnvios[indiceListEnvios].codigoPaquete}?",
        listaEnvios[indiceListEnvios]);
    if (respuestamodal) {
      desenfocarInputfx(context);
      setState(() {
        _paqueteController.text = "";
        _remitenteController.text = "";
        _destinatarioController.text = "";
        listaEnvios = [];
        button = false;
      });
    }
  }

  Widget itemEnvio(dynamic indice) {
    return ItemWidget(
        itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
        itemIndice: indice,
        methodAction: onPressedWidget,
        colorItem: indice % 2 == 0
            ? StylesThemeData.ITEM_UNSHADED_COLOR
            : StylesThemeData.ITEM_SHADED_COLOR,
        titulo: listaEnvios[indice].remitente != null
            ? "De: ${listaEnvios[indice].remitente}"
            : "De : Envío importado",
        subtitulo: "Para: ${listaEnvios[indice].destinatario}",
        subSecondtitulo: listaEnvios[indice].codigoPaquete,
        styleTitulo: StylesTitleData.STYLE_TITLE,
        styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
        styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
        onPressedCode: onPressedCode,
        subFivetitulo: listaEnvios[indice].codigoUbicacion,
        iconColor: StylesThemeData.ICON_COLOR);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                    iconSufix: IconsData.ICON_CAMERA,
                    methodOnPressedSufix: _traerdatosescanerPaquete,
                    controller: _paqueteController,
                    focusInput: f1paquete,
                    hinttext: "Código de paquete",
                    methodOnPressed: _validarPaqueteText,
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                    controller: _remitenteController,
                    focusInput: f2remitente,
                    hinttext: "De",
                    methodOnPressed: _validarRemitenteText,
                  )),
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputWidget(
                  controller: _destinatarioController,
                  focusInput: f3destinatario,
                  hinttext: "Para",
                  methodOnPressed: _validarDestinatarioText,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                width: double.infinity,
                child: ButtonWidget(
                    iconoButton: IconsData.ICON_SEARCH,
                    onPressed: buscarEnvios,
                    colorParam: StylesThemeData.PRIMARY_COLOR,
                    texto: "Buscar"),
              ),
            ],
          )),
          button
              ? ListItemWidget(
                  itemWidget: itemEnvio,
                  listItems: this.listaEnvios,
                  mostrarMensaje: true,
                )
              : Container(),
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Retirar envío"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
