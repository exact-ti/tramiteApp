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
import 'ConsultaEnvioController.dart';

class ConsultaEnvioPage extends StatefulWidget {
  @override
  _ConsultaEnvioPageState createState() => new _ConsultaEnvioPageState();
}

class _ConsultaEnvioPageState extends State<ConsultaEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  ConsultaEnvioController principalcontroller = new ConsultaEnvioController();
  List<EnvioModel> listaEnvios;
  FocusNode f1paquete = FocusNode();
  FocusNode f2remitente = FocusNode();
  FocusNode f3destinatario = FocusNode();
  bool pressButton = false;
  bool activo = false;
  bool button = false;

  void initState() {
    super.initState();
  }

  void _validarPaqueteText(dynamic valuePaquetecontroller) async {
    enfocarInputfx(context, f2remitente);
  }

  void _validarRemitenteText(dynamic valueRemitentecontroller) async {
    enfocarInputfx(context, f3destinatario);
  }

  Future _traerdatosescanerPaquete() async {
    _paqueteController.text = await getDataFromCamera(context);
    setState(() {
      _paqueteController.text = _paqueteController.text;
    });
    enfocarInputfx(context, f2remitente);
  }

  void listarEnvios(String paquete, String remitente, String destinatario,
      bool opcion) async {
    this.listaEnvios = await principalcontroller.listarEnvios(
        context, paquete, remitente, destinatario, opcion);
    if (this.listaEnvios.isNotEmpty) {
      setState(() {
        this.listaEnvios = this.listaEnvios;
      });
    } else {
      setState(() {
        this.listaEnvios.clear();
      });
    }
  }

  void onPresssedBuscarButton() {
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

  void onPressedCode(dynamic indiceListEnvios) {
    trackingPopUp(context, listaEnvios[indiceListEnvios].id);
  }

  @override
  Widget build(BuildContext context) {
    Widget mostrarText(bool opcion) {
      return Container(
          child: new GestureDetector(
        onTap: () {
          if (opcion) {
            listarEnvios(_paqueteController.text, _remitenteController.text,
                _destinatarioController.text, false);
            setState(() {
              activo = false;
            });
          } else {
            listarEnvios(_paqueteController.text, _remitenteController.text,
                _destinatarioController.text, true);
            setState(() {
              activo = true;
            });
          }
        },
        child: opcion == false
            ? Text(
                "Mostrar inactivos",
                style: TextStyle(color: Colors.black),
              )
            : Text(
                "Mostrar activos",
                style: TextStyle(color: Colors.blue),
              ),
      ));
    }

    Widget itemEnvio(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          iconPrimary: null,
          iconSend: null,
          itemIndice: indice,
          methodAction: null,
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
          subThirdtitulo: null,
          subFourtitulo: null,
          subFivetitulo: listaEnvios[indice].codigoUbicacion,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                      iconSufix: IconsData.ICON_CAMERA,
                      methodOnPressedSufix: _traerdatosescanerPaquete,
                      methodOnPressed: _validarPaqueteText,
                      controller: _paqueteController,
                      iconPrefix: IconsData.ICON_SOBRE,
                      focusInput: f1paquete,
                      align: null,
                      hinttext: "Código de paquete")),
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                      methodOnPressed: _validarRemitenteText,
                      controller: _remitenteController,
                      focusInput: f2remitente,
                      iconPrefix: IconsData.ICON_USER,
                      align: null,
                      hinttext: "De")),
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                      methodOnPressed: _validarRemitenteText,
                      controller: _destinatarioController,
                      focusInput: f3destinatario,
                      iconPrefix: IconsData.ICON_USER,
                      align: null,
                      hinttext: "Para")),
              Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  width: double.infinity,
                  child: ButtonWidget(
                      iconoButton: IconsData.ICON_SEARCH,
                      onPressed: onPresssedBuscarButton,
                      colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                      texto: "Buscar")),
            ],
          )),
          button
              ? paddingWidget(Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: mostrarText(activo),
                ))
              : Container(),
          button
              ? ListItemWidget(
                  itemWidget: itemEnvio,
                  listItems: listaEnvios,
                  mostrarMensaje: true,
                )
              : Container()
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Consultas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
