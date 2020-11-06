import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'RecepcionRegularController.dart';

class RecepcionInterPage extends StatefulWidget {
  final EnvioInterSedeModel recorridopage;

  const RecepcionInterPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _RecepcionInterPageState createState() =>
      new _RecepcionInterPageState(recorridopage);
}

class _RecepcionInterPageState extends State<RecepcionInterPage> {
  EnvioInterSedeModel recorridoUsuario;
  _RecepcionInterPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  RecepcionInterController principalcontroller = new RecepcionInterController();
  String mensajeconfirmation = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  mostrarenviosiniciales() async {
    listaEnvios = await principalcontroller.listarEnvios(
        context, _bandejaController.text);
    if (listaEnvios != null) {
      if (listaEnvios.length == 0) {
        setState(() {
          listaEnvios = [];
        });
      } else {
        setState(() {
          listaEnvios = listaEnvios;
        });
      }
    } else {
      setState(() {
        listaEnvios = [];
      });
    }
  }

  @override
  void initState() {
    if (recorridoUsuario != null) {
      _bandejaController.text = recorridoUsuario.codigo;
      mostrarenviosiniciales();
    }
    super.initState();
  }

  void sendButton() async {
    desenfocarInputfx(context);
    if (listaEnvios.length > 0) {
      bool respuestaarray = await confirmarArray(context, "success", "EXACT",
          "Faltan los siguientes elementos a validar", listaEnvios);
      if (respuestaarray == null) {
        Navigator.of(context).pop();
      } else {
        if (respuestaarray) {
          bool respuestatrue = await notificacion(context, "success", "EXACT",
              "Se ha recepcionado los documentos con éxito");
          if (respuestatrue != null) {
            if (respuestatrue) {
              Navigator.of(context).pushNamed('/envio-interutd');
            }
          }
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha completado con la recepción de documentos");
      if (respuestatrue != null) {
        if (respuestatrue) {
          Navigator.of(context).pushNamed('/envio-interutd');
        }
      }
    }
  }

  void _validarSobreText(dynamic valueSobreController) async {
    if (_bandejaController.text == "" || listaEnvios.length == 0) {
      setState(() {
        _sobreController.text = "";
      });
      popuptoinput(context, f1, "error", "EXACT",
          "Primero debe ingresar el codigo de la valija");
    } else {
      String value = valueSobreController;
      if (value != "") {
        bool perteneceLista = listaEnvios
            .where((envio) => envio.codigoPaquete == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          dynamic respuestaValidar = await principalcontroller.recogerdocumento(
              context, _bandejaController.text, value, true);
          if (respuestaValidar["status"] == "success") {
            listaEnvios.removeWhere((envio) => envio.codigoPaquete == value);
            if (listaEnvios.length == 0) {
              desenfocarInputfx(context);
              bool respuestatrue = await notificacion(context, "success",
                  "EXACT", "Se ha recepcionado los documentos con éxito");
              if (respuestatrue) {
                Navigator.of(context).pushNamed('/envio-interutd');
              }
            }
            setState(() {
              mensajeconfirmation = "El sobre $value fue recepcionado";
              listaEnvios = listaEnvios;
              _sobreController.text = value;
            });
          } else {
            setState(() {
              mensajeconfirmation = "No es posible procesar el código";
              _sobreController.text = value;
            });
          }
          enfocarInputfx(context, f2);
        } else {
          bool respuestaPopUp = await confirmacion(context, "success", "EXACT",
              "El código $value no se encuentra en la lista. ¿Desea continuar?");
          if (respuestaPopUp) {
            dynamic respuestaValidar =
                await principalcontroller.recogerdocumento(
                    context, _bandejaController.text, value, true);
            if (respuestaValidar["status"] != "success") {
              setState(() {
                mensajeconfirmation = "No es posible procesar el código";
                _sobreController.text = value;
              });
              enfocarInputfx(context, f2);
            } else {
              setState(() {
                mensajeconfirmation = "El sobre $value fue recepcionado";
                _sobreController.text = value;
              });
              enfocarInputfx(context, f2);
            }
          } else {
            enfocarInputfx(context, f2);
          }
        }
      } else {
        popuptoinput(context, f1, "error", "EXACT",
            "El ingreso del código de sobre es obligatorio");
      }
    }
  }

  void _validarBandejaText(dynamic valueBandejaController) async {
    String value = valueBandejaController;
    if (value != "") {
      listaEnvios = await principalcontroller.listarEnvios(context, value);
      if (listaEnvios.isNotEmpty) {
        setState(() {
          mensajeconfirmation = "";
          listaEnvios = listaEnvios;
        });
        enfocarInputfx(context, f2);
      } else {
        setState(() {
          mensajeconfirmation = "";
          listaEnvios = [];
          _bandejaController.text = value;
        });
        popuptoinput(
            context, f1, "error", "EXACT", "No es posible procesar el código");
      }
    } else {
      popuptoinput(
          context, f1, "error", "EXACT", "El código del lote es obligatorio");
    }
  }

  Future _traerdatosescanerSobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarSobreText(_sobreController.text);
  }

  Future _traerdatosescanerBandeja() async {
    _bandejaController.text = await getDataFromCamera(context);
    setState(() {
      _bandejaController.text = _bandejaController.text;
    });
    _validarBandejaText(_bandejaController.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCameraWidget(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerBandeja,
                    inputParam: InputWidget(
                        iconPrefix: IconsData.ICON_SOBRE,
                        methodOnPressed: _validarBandejaText,
                        controller: _bandejaController,
                        focusInput: f1,
                        hinttext: "Código de valija"))),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: InputCameraWidget(
                  iconData: Icons.camera_alt,
                  onPressed: _traerdatosescanerSobre,
                  inputParam: InputWidget(
                      iconPrefix: IconsData.ICON_SOBRE,
                      methodOnPressed: _validarSobreText,
                      controller: _sobreController,
                      focusInput: f2,
                      hinttext: "Código de sobre")),
              margin: const EdgeInsets.only(bottom: 20),
            ),
            mensajeconfirmation.length == 0
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Center(child: Text(mensajeconfirmation))),
            Expanded(
                child: Container(
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
                            iconColor: StylesThemeData.ICON_COLOR)))),
            listaEnvios.length > 0
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    alignment: Alignment.center,
                    child: ButtonWidget(
                      iconoButton: IconsData.ICON_FINISH,
                        onPressed: sendButton,
                        colorParam: StylesThemeData.PRIMARY_COLOR,
                        texto: "Terminar"))
                : Container(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recibir valijas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
