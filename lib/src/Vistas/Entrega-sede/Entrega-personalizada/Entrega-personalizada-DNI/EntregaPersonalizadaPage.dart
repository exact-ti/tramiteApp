import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'EntregaPersonalizadaController.dart';

class EntregapersonalizadoPageDNI extends StatefulWidget {
  @override
  _EntregapersonalizadoPageDNIState createState() =>
      new _EntregapersonalizadoPageDNIState();
}

class _EntregapersonalizadoPageDNIState
    extends State<EntregapersonalizadoPageDNI> {
  final _sobreController = TextEditingController();
  final _dniController = TextEditingController();
  EntregaPersonalizadaController personalizadacontroller =
      new EntregaPersonalizadaController();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<EnvioModel> listaEnvios = new List();
  FocusNode focusDNI = FocusNode();
  FocusNode focusSobre = FocusNode();
  @override
  void initState() {
    listaEnvios = [];
    super.initState();
  }

  void notifierAccion(String mensaje, String color) {
    final snack = new SnackBar(
      content: new Text("Se registró el envío"),
      backgroundColor: StylesThemeData.PRIMARY_COLOR,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  void _validarSobre(dynamic valueSobreController) async {
    if (_dniController.text == "") {
      _sobreController.text = "";
      notificacion(context, "error", "EXACT", "Primero debe ingresar el DNI");
    } else {
      if (valueSobreController != "") {
        if (listaEnvios
            .where((envio) => envio.codigoPaquete == valueSobreController)
            .toList()
            .isEmpty) {
          bool respuesta = await personalizadacontroller.guardarEntrega(
              context, _dniController.text, valueSobreController);
          if (respuesta) {
            desenfocarInputfx(context);
            EnvioModel envioModel = new EnvioModel();
            envioModel.codigoPaquete = valueSobreController;
            envioModel.estado = true;
            setState(() {
              _sobreController.text = "";
              listaEnvios.add(envioModel);
            });
            notifierAccion(
                "El envío $valueSobreController fue entregado correctamente",
                "38CE00");
          } else {
            popuptoinput(context, focusSobre, "error", "EXACT",
                "El código no existe, por favor intente nuevamente");
          }
        } else {
          popuptoinput(context, focusSobre, "error", "EXACT",
              "Código ya se encuentra validado");
        }
      } else {
        popuptoinput(context, focusSobre, "error", "EXACT",
            "El código de sobre es obligatorio");
      }
    }
  }

  void _validarDNI(dynamic valueDniController) {
    if (valueDniController == "") {
      popuptoinput(
          context, focusDNI, "error", "EXACT", "El DNI es obligatorio");
    } else {
      enfocarInputfx(context, focusSobre);
    }
  }

  Future _getDataCameraSobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarSobre(_sobreController.text);
  }

  Future _getDataCameraDNI() async {
    _dniController.text = await getDataFromCamera(context);
    setState(() {
      _dniController.text = _dniController.text;
    });
    _validarDNI(_dniController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        key: scaffoldkey,
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: InputCameraWidget(
                            iconData: Icons.camera_alt,
                            onPressed: _getDataCameraDNI,
                            inputParam: InputWidget(
                              iconPrefix: IconsData.ICON_SOBRE,
                              controller: _dniController,
                              focusInput: focusDNI,
                              hinttext: "Código",
                              methodOnPressed: _validarDNI,
                            ))),
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
                              itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
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
            context));
  }
}
