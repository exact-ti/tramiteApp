import 'dart:collection';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'ListarEnviosAgenciasController.dart';

final NavigationService _navigationService = locator<NavigationService>();

class ListarEnviosAgenciasPage extends StatefulWidget {
  @override
  _ListarEnviosAgenciasPageState createState() =>
      _ListarEnviosAgenciasPageState();
}

class _ListarEnviosAgenciasPageState extends State<ListarEnviosAgenciasPage> {
  ListarEnviosAgenciasController principalcontroller =
      new ListarEnviosAgenciasController();
  Map<String, dynamic> validados = new HashMap();
  List<EnvioInterSedeModel> enviosvalidados = new List();
  bool respuestaBack = false;

  @override
  void initState() {
    inicializarEnviosRecepcion();
    super.initState();
  }

  inicializarEnviosRecepcion() async {
    enviosvalidados =
        await principalcontroller.listarAgenciasExternasController();
    enviosvalidados.forEach((element) {
      int cod = element.utdId;
      validados["$cod"] = false;
    });
    setState(() {
      respuestaBack = true;
      enviosvalidados = enviosvalidados;
    });
  }

  void iniciarItem(EnvioInterSedeModel entrega) async {
    List<String> listids = new List();
    int idutd = entrega.utdId;
    listids.add("$idutd");
    bool confirmarInicio = await confirmacion(
        context, "success", "EXACT", "¿Desea iniciar el envío?");
    if (confirmarInicio) {
      bool respuesta =
          await principalcontroller.registrarlista(context, listids);
      if (respuesta) {
        notificacion(
            context, "success", "EXACT", "Se inició el envío correctamente");
        _navigationService.showModal();
        enviosvalidados =
            await principalcontroller.listarAgenciasExternasController();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          enviosvalidados = enviosvalidados;
        });
      } else {
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar el envío");
      }
    }
  }

  Color colorSelect(dynamic indice, bool seleccionado) {
    return seleccionado == null || seleccionado == false
        ? indice % 2 == 0
            ? StylesThemeData.ITEM_SHADED_COLOR
            : StylesThemeData.ITEM_UNSHADED_COLOR
        : StylesThemeData.ITEM_SELECT_COLOR;
  }

  void onPressedNuevaButton() {
    Navigator.of(context).pushNamed('/nuevo-agencia');
  }

  void registrarlista() async {
    List<String> listid = new List();
    validados
        .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));
    bool confirmarInicio = await confirmacion(
        context, "success", "EXACT", "¿Desea iniciar el envío de la valijas?");
    if (confirmarInicio) {
      bool respuesta =
          await principalcontroller.registrarlista(context, listid);
      if (respuesta) {
        notificacion(context, "success", "EXACT",
            "Se inició las entregas correctamente");
        _navigationService.showModal();

        validados.clear();
        enviosvalidados =
            await principalcontroller.listarAgenciasExternasController();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          enviosvalidados = enviosvalidados;
          validados = validados;
        });
      } else {
        validados.clear();
        enviosvalidados.forEach((element) {
          int cod = element.utdId;
          validados["$cod"] = false;
        });
        setState(() {
          enviosvalidados = enviosvalidados;
          validados = validados;
        });
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }
  }

  void onPressTap(dynamic indice) {
    String codigoUtd = enviosvalidados[indice].utdId.toString();
    bool contienevalidados = validados.containsValue(true);
    if (contienevalidados) {
      if (contienevalidados && validados["$codigoUtd"] == false) {
        setState(() {
          validados["$codigoUtd"] = true;
        });
      } else {
        setState(() {
          validados["$codigoUtd"] = false;
        });
      }
    } else {
      if (!validados.containsValue(true)) {
        iniciarItem(enviosvalidados[indice]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(dynamic indice) {
      String codigoUtd = enviosvalidados[indice].utdId.toString();
      String subtitulo = enviosvalidados[indice].numdocumentos == 1
          ? enviosvalidados[indice].numvalijas == 1
              ? "${enviosvalidados[indice].numdocumentos} destino (${enviosvalidados[indice].numvalijas} valija)"
              : "${enviosvalidados[indice].numdocumentos} destino (${enviosvalidados[indice].numvalijas} valijas)"
          : enviosvalidados[indice].numvalijas == 1
              ? "${enviosvalidados[indice].numdocumentos} destinos (${enviosvalidados[indice].numvalijas} valija)"
              : "${enviosvalidados[indice].numdocumentos} destinos (${enviosvalidados[indice].numvalijas} valijas)";
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigoUtd"] = true;
            });
          },
          child: ItemWidget(
            itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
            itemIndice: indice,
            methodAction: onPressTap,
            iconColor: StylesThemeData.ICON_COLOR,
            iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
            colorItem: colorSelect(indice, validados["$codigoUtd"]),
            titulo: enviosvalidados[indice].destino,
            subtitulo: subtitulo,
            styleTitulo: StylesTitleData.STYLE_TITLE,
            styleSubTitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
            iconPrimary: IconsData.ICON_SEDE,
          ));
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: FilaButtonWidget(
                    firsButton: ButtonWidget(
                        iconoButton: IconsData.ICON_NEW,
                        onPressed: onPressedNuevaButton,
                        colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                        texto: "Nuevo"))),
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
                  listItems: enviosvalidados,
                  mostrarMensaje: true,
                ),
          paddingWidget(
            validados.containsValue(true)
                ? Container(
                    margin: const EdgeInsets.only(bottom: 30, top: 20),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: ButtonWidget(
                        iconoButton: IconsData.ICON_SEND,
                        onPressed: registrarlista,
                        colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                        texto: "Enviar"))
                : Container(),
          )
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entregas externas"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }

  BoxDecoration myBoxDecoration(bool seleccionado) {
    return BoxDecoration(
      border: Border.all(color: StylesThemeData.LETTER_COLOR),
      color: seleccionado == null || seleccionado == false
          ? Colors.white
          : StylesThemeData.SELECTION_COLOR_2,
    );
  }
}
