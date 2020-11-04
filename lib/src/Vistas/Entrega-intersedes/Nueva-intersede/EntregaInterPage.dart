import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';
import 'EntregaInterController.dart';

class NuevoIntersedePage extends StatefulWidget {
  @override
  _NuevoIntersedePageState createState() => new _NuevoIntersedePageState();
}

class _NuevoIntersedePageState extends State<NuevoIntersedePage> {
  final _sobreController = TextEditingController();
  final _valijaController = TextEditingController();
  EntregaregularController principalcontroller = new EntregaregularController();
  List<EnvioModel> listaEnvios = [];
  FocusNode focusValija = FocusNode();
  FocusNode focusSobre = FocusNode();

  void initState() {
    super.initState();
  }

  void sendPress() async {
    if (_valijaController.text == "") {
      notificacion(context, "error", "EXACT", "Debe ingresar el codigo de bandeja");
    } else {
      if (listaEnvios.length != 0) {
        _sobreController.text = "";
        if (listaEnvios.where((envio) => !envio.estado).toList().isEmpty) {
          principalcontroller.confirmacionDocumentosValidadosEntrega(
              listaEnvios, context, _valijaController.text);
          _valijaController.text;
        } else {
          bool respuestaarray = await confirmarArray(
              context,
              "success",
              "EXACT",
              "Faltan los siguientes elementos a validar:",
              listaEnvios.where((envio) => !envio.estado).toList());
          if (respuestaarray) {
            principalcontroller.confirmacionDocumentosValidadosEntrega(
                listaEnvios.where((envio) => envio.estado).toList(),
                context,
                _valijaController.text);
          }
        }
      } else {
        notificacion(context, "error", "EXACT", "No hay envíos para registrar");
      }
    }
  }

  void _validarSobreText(dynamic valueSobreController) async {
    if (_valijaController.text == "") {
      _sobreController.text = "";
      bool respuestatrue = await notificacion(context, "error", "EXACT",
          "Primero debe ingresar el codigo de la bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, focusValija);
      }
    } else {
      String value = valueSobreController;
      if (value != "") {
        bool perteneceLista = listaEnvios
            .where((envio) => envio.codigoPaquete == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          setState(() {
            listaEnvios.forEach((envio) {
              if (envio.codigoPaquete == value) {
                envio.estado = true;
              }
            });
            _sobreController.text = "";
          });
          enfocarInputfx(context, focusSobre);
        } else {
          EnvioModel enviocontroller = await principalcontroller.validarCodigoEntrega(_valijaController.text, value, context);
          if (enviocontroller != null) {
            setState(() {
              _sobreController.text = "";
              listaEnvios.add(enviocontroller);
            });
            bool respuestatrue = await notificacion(context, "success", "EXACT", "Envío agregado a la entrega");
            if (respuestatrue) {
              enfocarInputfx(context, focusSobre);
            }
          } else {
            setState(() {
              _sobreController.text = value;
            });
            bool respuestatrue = await notificacion(context, "error", "EXACT", "No es posible procesar el código");
            if (respuestatrue) {
              enfocarInputfx(context, focusSobre);
            }
          }
        }
      } else {
        bool respuestatrue = await notificacion(
            context, "error", "EXACT", "El campo del sobre no puede ser vacío");
        if (respuestatrue) {
          enfocarInputfx(context, focusSobre);
        }
      }
    }
  }

  void validarListaByBandeja(dynamic valueBandejaController) async {
    String codigo = valueBandejaController;
    if (codigo != "") {
      listaEnvios = await principalcontroller.listarEnviosEntrega(context, codigo);
      if (listaEnvios.isNotEmpty) {
        setState(() {
          listaEnvios = listaEnvios;
          _sobreController.text = "";
        });
        enfocarInputfx(context, focusSobre);
      } else {
        bool respuestatrue = await notificacion(
            context, "error", "EXACT", "No es posible procesar el código");
        setState(() {
          _sobreController.text = "";
          listaEnvios = [];
          _valijaController.text = codigo;
        });
        if (respuestatrue) {
          enfocarInputfx(context, focusValija);
        }
      }
    } else {
      bool respuestatrue = await notificacion(
          context, "error", "EXACT", "Debe ingresar el código de bandeja");
      if (respuestatrue) {
        enfocarInputfx(context, focusValija);
      }
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
    _valijaController.text = await getDataFromCamera(context);
    setState(() {
      _valijaController.text = _valijaController.text;
    });
    validarListaByBandeja(_valijaController.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCameraWidget(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerBandeja,
                    inputParam: InputWidget(
                        iconPrefix: IconsData.ICON_SOBRE,
                        methodOnPressed: validarListaByBandeja,
                        controller: _valijaController,
                        focusInput: focusValija,
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
                      focusInput: focusSobre,
                      hinttext: "Código de sobre")),
              margin: const EdgeInsets.only(bottom: 30),
            ),
            Expanded(child: ListView.builder(
                            itemCount: listaEnvios.length,
                            itemBuilder: (context, i) => ItemWidget(
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
            listaEnvios.where((envio) => envio.estado).toList().isNotEmpty
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 30,top: 10),
                    child: ButtonWidget(
                        onPressed: sendPress,
                        colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                        texto: "Registrar"))
                : Container(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Nueva entrega"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
