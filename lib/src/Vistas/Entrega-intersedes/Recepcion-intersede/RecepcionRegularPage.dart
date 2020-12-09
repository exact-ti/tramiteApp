import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
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
  final _valijaController = TextEditingController();
  List<EnvioModel> listaEnvios;
  EnvioModel _envioModel = new EnvioModel();
  RecepcionInterController principalcontroller = new RecepcionInterController();
  String mensajeconfirmation = "";
  FocusNode focusValija = FocusNode();
  FocusNode focusSobre = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => inicializarEnvios());
    super.initState();
  }

  void inicializarEnvios() {
    if (this.mounted) {
      Map valija = ModalRoute.of(context).settings.arguments;
      if (valija["codValija"] != null) {
        _valijaController.text = valija['codValija'];
        mostrarenviosiniciales();
      } else {
        setState(() {
          listaEnvios = [];
        });
      }
    }
  }

  mostrarenviosiniciales() async {
    listaEnvios =
        await principalcontroller.listarEnvios(context, _valijaController.text);
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
    if (_valijaController.text == "" || listaEnvios.length == 0) {
      setState(() {
        _sobreController.text = "";
      });
      popuptoinput(context, focusValija, "error", "EXACT",
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
              context, _valijaController.text, value, true);
          if (respuestaValidar["status"] == "success") {
            listaEnvios.removeWhere((envio) => envio.codigoPaquete == value);
            if (listaEnvios.isEmpty) {
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
        } else {
          bool respuestaPopUp = await confirmacion(context, "success", "EXACT",
              "El código $value no se encuentra en la lista. ¿Desea continuar?");
          if (respuestaPopUp) {
            dynamic respuestaValidar = await principalcontroller
                .recogerdocumento(context, _valijaController.text, value, true);
            if (respuestaValidar["status"] != "success") {
              setState(() {
                mensajeconfirmation = "No es posible procesar el código";
                _sobreController.text = value;
              });
            } else {
              setState(() {
                mensajeconfirmation = "El sobre $value fue recepcionado";
                _sobreController.text = value;
              });
            }
          }
        }
        if (listaEnvios.isNotEmpty) {
          selectionText(_sobreController, focusSobre, context);
        }
      } else {
        popuptoinput(context, focusValija, "error", "EXACT",
            "El ingreso del código de sobre es obligatorio");
      }
    }
  }

  /*     return envioModel.fromJsonValidar(resp.data);
 */

  void _validarBandejaText(dynamic valueBandejaController) async {
    String value = valueBandejaController;
    if (value != "") {
      dynamic respuestaData =
          await principalcontroller.listarEnvios(context, value);
      if (respuestaData["status"] == "success") {
        setState(() {
          mensajeconfirmation = "";
          listaEnvios = _envioModel.fromJsonValidar(respuestaData["data"]);
        });
        enfocarInputfx(context, focusSobre);
      } else {
        setState(() {
          mensajeconfirmation = "";
          listaEnvios = [];
          _valijaController.text = value;
        });
        popuptoinput(
            context, focusValija, "error", "EXACT", respuestaData["message"]);
      }
    } else {
      popuptoinput(context, focusValija, "error", "EXACT",
          "El código del lote es obligatorio");
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
    _validarBandejaText(_valijaController.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemInterSede(indice) {
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

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: InputWidget(
                      iconSufix: IconsData.ICON_CAMERA,
                      methodOnPressedSufix: _traerdatosescanerBandeja,
                      iconPrefix: IconsData.ICON_SOBRE,
                      methodOnPressed: _validarBandejaText,
                      controller: _valijaController,
                      focusInput: focusValija,
                      hinttext: "Código de valija")),
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputWidget(
                    iconSufix: IconsData.ICON_CAMERA,
                    methodOnPressedSufix: _traerdatosescanerSobre,
                    iconPrefix: IconsData.ICON_SOBRE,
                    methodOnPressed: _validarSobreText,
                    controller: _sobreController,
                    focusInput: focusSobre,
                    hinttext: "Código de sobre"),
                margin: const EdgeInsets.only(bottom: 20),
              ),
            ],
          )),
          mensajeconfirmation.length == 0
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Center(child: Text(mensajeconfirmation))),
          ListItemWidget(itemWidget: itemInterSede, listItems: listaEnvios),
          listaEnvios != null && listaEnvios.length > 0
              ? paddingWidget(Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  alignment: Alignment.center,
                  child: ButtonWidget(
                      iconoButton: IconsData.ICON_FINISH,
                      onPressed: sendButton,
                      colorParam: StylesThemeData.PRIMARY_COLOR,
                      texto: "Terminar")))
              : Container(),
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Recibir valijas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
