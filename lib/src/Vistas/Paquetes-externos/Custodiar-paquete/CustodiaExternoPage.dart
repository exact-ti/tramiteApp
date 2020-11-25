import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoController.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';

class CustodiaExternoPage extends StatefulWidget {
  @override
  _CustodiaExternoPageState createState() => new _CustodiaExternoPageState();
}

class _CustodiaExternoPageState extends State<CustodiaExternoPage> {
  CustodiaController custodiaController = new CustodiaController();
  List<PaqueteExterno> listPaqueteExternos;
  final _codigoController = TextEditingController();
  FocusNode f1 = FocusNode();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    listarEnviosToValidar();
    super.initState();
  }

  void listarEnviosToValidar() async {
    listPaqueteExternos =
        await custodiaController.listarPaquetesExternosCreados();
    if (this.mounted) {
      setState(() {
        listPaqueteExternos = listPaqueteExternos;
      });
    }
  }

  void notifierAccion(String mensaje, Color colorNotifier) {
    final snack = new SnackBar(
      content: new Text(mensaje),
      backgroundColor: colorNotifier,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  void _custodiarConCamara() async {
    _codigoController.text = await getDataFromCamera(context);
    setState(() {
      _codigoController.text = _codigoController.text;
    });
    _validarCodigoPaquete(_codigoController.text);
  }

  void _validarCodigoPaquete(dynamic value) async {
    desenfocarInputfx(context);
    if (value != "") {
      dynamic custodiado = await custodiaController.custodiarPaquete(value);
      if (custodiado["status"]=="success") {
        bool perteneceLista = listPaqueteExternos
            .where((paqueteExterno) => paqueteExterno.paqueteId == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          setState(() {
            listPaqueteExternos.removeWhere(
                (paqueteExterno) => paqueteExterno.paqueteId == value);
          });
        }
        setState(() {
          _codigoController.clear();
        });
        notifierAccion(
            "Se ha custodiado el envío", StylesThemeData.PRIMARY_COLOR);
      } else {
        notifierAccion(
            custodiado["message"], StylesThemeData.ERROR_COLOR);
      }
    } else {
      notifierAccion(
          "El código del envío es obligatorio", StylesThemeData.ERROR_COLOR);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget itemExternoWidget(itemIndice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
          itemIndice: itemIndice,
          iconPrimary: IconsData.ICON_QR,
          iconColor: StylesThemeData.ICON_COLOR,
          colorItem: itemIndice % 2 == 0
              ? StylesThemeData.ITEM_UNSHADED_COLOR
              : StylesThemeData.ITEM_SHADED_COLOR,
          titulo: this.listPaqueteExternos[itemIndice].paqueteId);
    }

    return Scaffold(
        key: scaffoldkey,
        appBar: CustomAppBar(text: "Custodiar envíos"),
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
                      methodOnPressedSufix: _custodiarConCamara,
                      controller: _codigoController,
                      focusInput: f1,
                      hinttext: "Ingresar código",
                      methodOnPressed: _validarCodigoPaquete,
                    ),
                  ),
                ),
                ListItemWidget(
                  itemWidget: itemExternoWidget,
                  listItems: this.listPaqueteExternos,
                  mostrarMensaje: true,
                )
              ],
            )),
            context));
  }
}
