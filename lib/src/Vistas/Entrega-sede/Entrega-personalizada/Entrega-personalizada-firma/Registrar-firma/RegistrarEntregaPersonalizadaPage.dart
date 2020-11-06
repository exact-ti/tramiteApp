import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
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

  @override
  Widget build(BuildContext context) {
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
            notifierAccion(
                "Se registró la entrega", StylesThemeData.PRIMARY_COLOR);
          } else {
            setState(() {
              _sobreController.text = "";
            });
            notifierAccion(respuesta["message"], Colors.red);
          }
        } else {
          notifierAccion("Código ya se encuentra validado", Colors.red);
        }
      } else {
        notifierAccion("el código de sobre es obligatorio", Colors.red);
      }
    }

    Future _getDataCameraSobre() async {
      _sobreController.text = await getDataFromCamera(context);
      setState(() {
        _sobreController.text = _sobreController.text;
      });
      _validarSobre(_sobreController.text);
    }

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
                    child: InputCameraWidget(
                        iconData: Icons.camera_alt,
                        onPressed: _getDataCameraSobre,
                        inputParam: InputWidget(
                          iconPrefix: IconsData.ICON_SOBRE,
                          controller: _sobreController,
                          focusInput: focusSobre,
                          hinttext: "Código de sobre",
                          methodOnPressed: _validarSobre,
                        )),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                ],
              )),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                        itemCount: listaEnvios.length,
                        itemBuilder: (context, i) => ItemWidget(
                           itemHeight:
                                  StylesItemData.ITEM_HEIGHT_ONE_TITLE,
                            iconPrimary: FontAwesomeIcons.qrcode,
                            iconSend: listaEnvios[i].estado
                                ? IconsData.ICON_ENVIO_CONFIRMADO
                                : null,
                            itemIndice: i,
                            methodAction: null,
                            colorItem: i % 2 == 0
                                ? StylesThemeData.ITEM_SHADED_COLOR
                                : StylesThemeData.ITEM_UNSHADED_COLOR,
                            titulo: listaEnvios[i].codigoPaquete,
                            subtitulo: null,
                            subSecondtitulo: null,
                            styleTitulo: StylesTitleData.STYLE_TITLE,
                            styleSubTitulo: null,
                            styleSubSecondtitulo: null,
                            iconColor: StylesThemeData.ICON_COLOR))),
              ),
            ],
          ),
        )));
  }
}
