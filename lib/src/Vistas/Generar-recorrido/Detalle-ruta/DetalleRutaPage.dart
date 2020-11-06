import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/TabSectionWidget.dart';
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

  String obtenerTituloInEntregas(dynamic intersedeIndice) {
    return listDetallesEntregar[intersedeIndice].destinatario;
  }

  String obtenerTituloInRecojos(dynamic intersedeIndice) {
    return listDetallesRecoger[intersedeIndice].destinatario;
  }

  String obtenerSubTituloInEntregas(dynamic intersedeIndice) {
    return listDetallesEntregar[intersedeIndice].paqueteId;
  }

  String obtenerSubTituloInRecojos(dynamic intersedeIndice) {
    return listDetallesRecoger[intersedeIndice].paqueteId;
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
              child: TabSectionWidget(
            itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
            iconPrimerTap: IconsData.ICON_POR_RECIBIR,
            iconSecondTap: IconsData.ICON_ENVIADOS,
            namePrimerTap: "Por entregar",
            nameSecondTap: "Por recoger",
            listPrimerTap: listDetallesEntregar,
            listSecondTap: listDetallesRecoger,
            methodPrimerTap: null,
            methodSecondTap: null,
            primerIconWiget: null,
            obtenerSecondIconWigetInPrimerTap: null,
            obtenerSecondIconWigetInSecondTap: null,
            obtenerTituloInPrimerTap: obtenerTituloInEntregas,
            obtenerSubTituloInPrimerTap: null,
            obtenerSubSecondtituloInPrimerTap: obtenerSubTituloInEntregas,
            obtenerTituloInSecondTap: obtenerTituloInRecojos,
            obtenerSubTituloInSecondTap: null,
            methodCodePrimerTap: methodPopUpInEntregas,
            methodCodeSecondTap: methodPopUpInRecojos,
            obtenerSubSecondtituloInSecondTap: obtenerSubTituloInRecojos,
            styleTitulo: StylesTitleData.STYLE_TITLE,
            styleSubTitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
            styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
            iconWidgetColor: StylesThemeData.ICON_COLOR,
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
