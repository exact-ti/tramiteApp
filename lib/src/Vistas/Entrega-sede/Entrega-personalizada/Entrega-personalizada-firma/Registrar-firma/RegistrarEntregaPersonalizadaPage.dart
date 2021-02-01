import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'RegistrarEntregaPersonalizadaController.dart';

class RegistrarEntregapersonalizadoPage extends StatefulWidget {
  final dynamic firma;

  const RegistrarEntregapersonalizadoPage({Key key, this.firma})
      : super(key: key);

  @override
  _RegistrarEntregapersonalizadoPageState createState() =>
      new _RegistrarEntregapersonalizadoPageState(firma);
}

class _RegistrarEntregapersonalizadoPageState
    extends State<RegistrarEntregapersonalizadoPage> {
  dynamic imagenFirma;
  _RegistrarEntregapersonalizadoPageState(this.imagenFirma);
  final _sobreController = TextEditingController();
  RegistrarEntregaPersonalizadaController personalizadacontroller =
      new RegistrarEntregaPersonalizadaController();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<EnvioModel> listaEnvios = new List();
  FocusNode focusSobre = FocusNode();
  @override
  void initState() {
    listaEnvios = [];
    super.initState();
  }

  void notifierAccion(String mensaje, Color color) {
    final snack = new SnackBar(
      content: new Text(mensaje),
      backgroundColor: color,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  void _validarSobre(dynamic valuesobreController) async {
    if (valuesobreController != "") {
      if (listaEnvios
          .where((envio) => envio.codigoPaquete == valuesobreController)
          .toList()
          .isEmpty) {
        dynamic respuesta = await personalizadacontroller.guardarEntrega(
            context, imagenFirma, valuesobreController);
        if (respuesta.containsValue("success")) {
          desenfocarInputfx(context);
          EnvioModel envioModel = new EnvioModel();
          envioModel.codigoPaquete = valuesobreController;
          envioModel.estado = true;
          setState(() {
            listaEnvios.add(envioModel);
          });
          selectionText(_sobreController, focusSobre, context);
          notifierAccion(
              "Se registró la entrega", StylesThemeData.PRIMARY_COLOR);
        } else {
          selectionText(_sobreController, focusSobre, context);
          notifierAccion(respuesta["message"], StylesThemeData.ERROR_COLOR);
        }
      } else {
        selectionText(_sobreController, focusSobre, context);
        notifierAccion("Código ya se encuentra validado", StylesThemeData.ERROR_COLOR);
      }
    } else {
      notifierAccion("el código de sobre es obligatorio", StylesThemeData.ERROR_COLOR);
    }
  }

  Future _getDataCameraSobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarSobre(_sobreController.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget campodetextoandIconoFIRMA = Container(
      child: LimitedBox(
          maxHeight: screenHeightExcludingToolbar(context, dividedBy: 5),
          child: Container(
              child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(90 / 360),
                  child: Container(
                      child: Image.memory(
                          Base64Decoder().convert(imagenFirma)))))),
    );

    Widget itemWidget(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
          iconPrimary: FontAwesomeIcons.qrcode,
          iconSend: listaEnvios[indice].estado
              ? IconsData.ICON_ENVIO_CONFIRMADO
              : null,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listaEnvios[indice].codigoPaquete,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        key: scaffoldkey,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              paddingWidget(Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    child: Text("Firma"),
                    margin: const EdgeInsets.only(top: 20),
                  ),
                  Container(
                    width: double.infinity,
                    child: campodetextoandIconoFIRMA,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: InputWidget(
                      iconSufix: IconsData.ICON_CAMERA,
                      methodOnPressedSufix: _getDataCameraSobre,
                      iconPrefix: IconsData.ICON_SOBRE,
                      controller: _sobreController,
                      focusInput: focusSobre,
                      hinttext: "Código de sobre",
                      methodOnPressed: _validarSobre,
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                ],
              )),
              ListItemWidget(itemWidget: itemWidget, listItems: listaEnvios),
            ],
          ),
        )));
  }
}
