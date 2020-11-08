import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionWidget2.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'DetalleRutaController.dart';

class DetalleRutaPage extends StatefulWidget {
  final dynamic objetoModo;
  const DetalleRutaPage({Key key, this.objetoModo}) : super(key: key);

  @override
  _DetalleRutaPagePageState createState() =>
      _DetalleRutaPagePageState(this.objetoModo);
}

class _DetalleRutaPagePageState extends State<DetalleRutaPage> {
  dynamic objetoModo;
  int recorridoID;
  RutaModel rutaModel;
  _DetalleRutaPagePageState(this.objetoModo);
  DetalleRutaController principalcontroller = new DetalleRutaController();
  List<DetalleRutaModel> detallesRuta = new List();
  List<bool> isSelected;
  bool porEntregar = true;
  int indexSwitch = 0;
  List<DetalleRutaModel> listDetallesEntregar;
  List<DetalleRutaModel> listDetallesRecoger;

  @override
  void initState() {
    isSelected = [true, false];
    this.recorridoID = objetoModo["recorridoId"];
    this.rutaModel = objetoModo["ruta"];
    listarEnviosIntersedes();
    super.initState();
  }

  void listarEnviosIntersedes() async {
    listDetallesEntregar = await principalcontroller.listarDetalleRuta(
        porEntregar, rutaModel.id, recorridoID);
    listDetallesRecoger = await principalcontroller.listarDetalleRuta(
        !porEntregar, rutaModel.id, recorridoID);
    if (this.mounted) {
      setState(() {
        listDetallesEntregar = listDetallesEntregar;
        listDetallesRecoger = listDetallesRecoger;
      });
    }
  }

  void methodPopUpInEntregas(dynamic intersedeIndice) {
    trackingPopUp(context, listDetallesEntregar[intersedeIndice].id);
  }

  void methodPopUpInRecojos(dynamic intersedeIndice) {
    trackingPopUp(context, listDetallesRecoger[intersedeIndice].id);
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionArea() {
      return Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Text('Área:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${rutaModel.nombre}'),
                    flex: 5,
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Ubicación:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${rutaModel.ubicacion}'),
                    flex: 5,
                  ),
                ],
              ))
        ],
      ));
    }

    Widget itemEntregar(dynamic indice) {
      return ItemWidget(
          itemHeight:  StylesItemData.ITEM_HEIGHT_TWO_TITLE,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listDetallesEntregar[indice].destinatario,
          subSecondtitulo: listDetallesEntregar[indice].paqueteId,
          iconSend: IconsData.ICON_MAIL,
          onPressedCode: methodPopUpInEntregas,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed);
    }

    Widget itemRecoger(dynamic indice) {
      return ItemWidget(
          itemHeight:  StylesItemData.ITEM_HEIGHT_TWO_TITLE,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listDetallesRecoger[indice].destinatario,
          subSecondtitulo: listDetallesRecoger[indice].paqueteId,
          iconSend: IconsData.ICON_MAIL,
          onPressedCode: methodPopUpInRecojos,
          iconColor: StylesThemeData.ICON_COLOR,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed);
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: informacionArea()),
            ],
          )),
          Expanded(
              child: TabSectionWidget2(
            iconPrimerTap: IconsData.ICON_POR_RECIBIR,
            iconSecondTap: IconsData.ICON_ENVIADOS,
            namePrimerTap: "Por entregar",
            nameSecondTap: "Por recoger",
            listPrimerTap: listDetallesEntregar,
            listSecondTap: listDetallesRecoger,
            itemPrimerTapWidget: itemEntregar,
            itemSecondTapWidget: itemRecoger,
          ))
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Detalle de mi ruta"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
