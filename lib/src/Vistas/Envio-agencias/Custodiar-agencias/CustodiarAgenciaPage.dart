import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'CustodiarAgenciaController.dart';

class CustodiarAgenciaPage extends StatefulWidget {
  @override
  _CustodiarAgenciaPageState createState() => new _CustodiarAgenciaPageState();
}

class _CustodiarAgenciaPageState extends State<CustodiarAgenciaPage> {
  CustodiarAgenciaController custodiaAgenciaController =
      new CustodiarAgenciaController();
  List<EnvioModel> listEnviosAgencias;
  final _codigoController = TextEditingController();
  FocusNode focusCodigo = FocusNode();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    custodiaAgenciaController
        .inicializarListEnviosAgencias(setStateListEnviosAgencia);
    super.initState();
  }

  void setStateListEnviosAgencia(dynamic listEnviosAgencias) {
    setState(() {
      this.listEnviosAgencias = listEnviosAgencias;
    });
  }

  void setStateCodigoTextForm(dynamic codigoTextForm) {
    setState(() {
      this._codigoController.text = codigoTextForm;
    });
  }

    void onPressEnvio(dynamic indice) async {
    bool respuestaConfirmacion = await confirmacion(context, "success", "EXACT",
        "El documento ${listEnviosAgencias[indice].codigoPaquete} no se encuentra. ¿Deseas enviar una notificación?");
    if (respuestaConfirmacion) {
      dynamic responseNotificacion = await custodiaAgenciaController.enviarNotificacion(listEnviosAgencias[indice].codigoPaquete);
      if (responseNotificacion["status"] == "success") {
        notificacion(
            context, "success", "EXACT", "La notificación fue realizada");
      } else {
        notificacion(
            context, "error", "EXACT", responseNotificacion["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void custodiarConCamara() {
      custodiaAgenciaController.custodiarConCamara(
          context,
          setStateCodigoTextForm,
          this.listEnviosAgencias,
          this.scaffoldkey,
          setStateListEnviosAgencia,
          focusCodigo,
          _codigoController);
    }

    void validarCodigoPaquete(dynamic value) {
      custodiaAgenciaController.validarCodigoPaquete(
          value,
          context,
          this.listEnviosAgencias,
          this.scaffoldkey,
          setStateListEnviosAgencia,
          focusCodigo,
          _codigoController);
    }

    return Scaffold(
        key: scaffoldkey,
        appBar: CustomAppBar(text: "Custodiar entregas externas"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: InputWidget(
                      iconSufix: IconsData.ICON_CAMERA,
                      methodOnPressedSufix: custodiarConCamara,
                      controller: _codigoController,
                      focusInput: focusCodigo,
                      iconPrefix: IconsData.ICON_SOBRE,
                      hinttext: "Ingresar código",
                      methodOnPressed: validarCodigoPaquete,
                    ),
                  ),
                ),
                ListItemWidget(
                  itemWidget: (indice) => ItemWidget(
                      itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
                      itemIndice: indice,
                      methodAction: onPressEnvio,
                      iconSend: IconsData.ICON_SEND_ARROW,
                      iconPrimary: IconsData.ICON_QR,
                      iconColor: StylesThemeData.ICON_COLOR,
                      colorItem: indice % 2 == 0
                          ? StylesThemeData.ITEM_UNSHADED_COLOR
                          : StylesThemeData.ITEM_SHADED_COLOR,
                      titulo: this.listEnviosAgencias[indice].codigoPaquete),
                  listItems: this.listEnviosAgencias,
                  mostrarMensaje: true,
                )
              ],
            )),
            context));
  }
}
