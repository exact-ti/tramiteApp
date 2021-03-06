import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/TrackingModal.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'RecepcionController.dart';

class RecepcionEnvioPage extends StatefulWidget {
  @override
  _RecepcionEnvioPageState createState() => new _RecepcionEnvioPageState();
}

class _RecepcionEnvioPageState extends State<RecepcionEnvioPage> {
  final _bandejaController = TextEditingController();
  List<String> listaEnvios = new List();
  List<EnvioModel> listaEnviosModel = new List();
  RecepcionController principalcontroller = new RecepcionController();
  Map<String, dynamic> validados = new HashMap();
  bool respuestaBack = false;
  final NavigationService _navigationService = locator<NavigationService>();
  FocusNode focusBandeja = FocusNode();
  final _prefs = new PreferenciasUsuario();

  @override
  void initState() {
    inicializarEnviosRecepcion();
    super.initState();
  }

  inicializarEnviosRecepcion() async {
    listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
    listaEnviosModel.forEach((element) {
      String cod = element.codigoPaquete;
      validados["$cod"] = false;
    });
    if (mounted) {
      _prefs.openByNotificationPush=null;
      setState(() {
        respuestaBack = true;
        listaEnviosModel = listaEnviosModel;
      });
    }
  }

  void onPressedCode(dynamic indice) {
    String codigopaquete = listaEnviosModel[indice].codigoPaquete;

    if (validados["$codigopaquete"] == null ||
        validados["$codigopaquete"] == false) {
      if (!validados.containsValue(true)) {
        showDialog(
            context: context,
            builder: (_) {
              return TrackingModal(
                paqueteId: listaEnviosModel[indice].id,
              );
            });
      }
    }
  }

  void onpressedTap(dynamic indice) {
    String codigopaquete = listaEnviosModel[indice].codigoPaquete;
    bool contienevalidados = validados.containsValue(true);
    if (contienevalidados && validados["$codigopaquete"] == false) {
      setState(() {
        validados["$codigopaquete"] = true;
      });
    } else {
      setState(() {
        validados["$codigopaquete"] = false;
      });
    }
  }

  Color colorSelect(dynamic indice, bool seleccionado) {
    return seleccionado == null || seleccionado == false
        ? indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR
        : StylesThemeData.ITEM_SELECT_COLOR;
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(dynamic indice) {
      String codigopaquete = listaEnviosModel[indice].codigoPaquete;
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigopaquete"] = true;
            });
          },
          child: ItemWidget(
              itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
              itemIndice: indice,
              colorItem: colorSelect(indice, validados["$codigopaquete"]),
              titulo: listaEnviosModel[indice].usuario == null
                  ? "De: Envío importado"
                  : "De: ${listaEnviosModel[indice].usuario}",
              subSecondtitulo: listaEnviosModel[indice].codigoPaquete,
              subFivetitulo: listaEnviosModel[indice].observacion,
              styleTitulo: StylesTitleData.STYLE_TITLE,
              styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
              styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
              onPressedCode: onPressedCode,
              methodAction: onpressedTap,
              iconColor: StylesThemeData.ICON_COLOR));
    }

    void validarEnvio(List<String> listid, int cantidad) async {
      bool respuestaLista =
          await principalcontroller.guardarLista(context, listid);
      if (respuestaLista) {
        bool respuesta = await notificacion(
            context,
            "success",
            "EXACT",
            cantidad == 1
                ? "Se recepcionó el envío"
                : "Se recepcionó los envíos");

        if (respuesta) {
          _navigationService.showModal();
          listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
          validados.clear();
          listaEnviosModel.forEach((element) {
            String cod = element.codigoPaquete;
            validados["$cod"] = false;
          });
          _navigationService.goBack();
          setState(() {
            validados = validados;
            listaEnviosModel = listaEnviosModel;
          });
          if (listaEnviosModel.isNotEmpty) {
            selectionText(_bandejaController, focusBandeja, context);
          }
        }
      } else {
        bool respuesta = await notificacion(
            context,
            "error",
            "EXACT",
            cantidad == 1
                ? "No es posible procesar el código"
                : "No es posible procesar los códigos");
        if (respuesta) {
          validados.clear();
          selectionText(_bandejaController, focusBandeja, context);
        }
      }
    }

    void _validarBandejaText(dynamic valueBandejaController) {
      if (valueBandejaController != "") {
        List<String> lista = new List();
        lista.add(valueBandejaController);
        validarEnvio(lista, 1);
      }
    }

    Future _traerdatosescanerBandeja() async {
      if (!validados.containsValue(true)) {
        _bandejaController.text = await getDataFromCamera(context);
        setState(() {
          _bandejaController.text = _bandejaController.text;
        });
        _validarBandejaText(_bandejaController.text);
      }
    }

    void registrarLista() {
      List<String> listid = new List();
      validados
          .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));
      validarEnvio(listid, 2);
    }

    mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(
            Container(
                margin: const EdgeInsets.only(bottom: 30, top: 20),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputWidget(
                  iconPrefix: IconsData.ICON_QR,
                    iconSufix: IconsData.ICON_CAMERA,
                    methodOnPressedSufix: _traerdatosescanerBandeja,
                    controller: _bandejaController,
                    focusInput: focusBandeja,
                    methodOnPressed: _validarBandejaText,
                    hinttext: "Envío")),
          ),
          !respuestaBack
              ? Expanded(
                  child: Container(
                      child: Center(
                          child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ))))
              : ListItemWidget(
                  itemWidget: crearItem,
                  listItems: listaEnviosModel,
                  mostrarMensaje: true,
                ),
          validados.containsValue(true)
              ? paddingWidget(Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: ButtonWidget(
                      iconoButton: IconsData.ICON_RECEIVE,
                      onPressed: registrarLista,
                      colorParam: StylesThemeData.PRIMARY_COLOR,
                      texto: "Recepcionar")))
              : Container()
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          text: "Confirmar envíos",
          leadingbool: boolIfPerfil() ? false : true,
        ),
        drawer: drawerIfPerfil(),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }
}
