import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'ItemsWidget/ItemWidget.dart';

class TabSectionWidgetsdf extends StatelessWidget {
  final IconData iconPrimerTap;
  final IconData iconSecondTap;
  final String namePrimerTap;
  final String nameSecondTap;
  final List<dynamic> listPrimerTap;
  final List<dynamic> listSecondTap;
  final ValueChanged<dynamic> methodPrimerTap;
  final ValueChanged<dynamic> methodSecondTap;
  final ValueChanged<dynamic> methodCodeSecondTap;
  final ValueChanged<dynamic> methodCodePrimerTap;

  final IconData primerIconWiget;
  final IconData Function(dynamic) obtenerSecondIconWigetInPrimerTap;
  final IconData Function(dynamic) obtenerSecondIconWigetInSecondTap;
  final String Function(dynamic) obtenerTituloInPrimerTap;
  final String Function(dynamic) obtenerSubTituloInPrimerTap;
  final String Function(dynamic) obtenerSubSecondtituloInPrimerTap;
  final String Function(dynamic) obtenerSubThirdtituloInPrimerTap;
  final String Function(dynamic) obtenerSubFourdtituloInPrimerTap;
  final String Function(dynamic) obtenerSubFivetituloInPrimerTap;
  final String Function(dynamic) obtenerTituloInSecondTap;
  final String Function(dynamic) obtenerSubTituloInSecondTap;
  final String Function(dynamic) obtenerSubSecondtituloInSecondTap;
  final String Function(dynamic) obtenerSubThirdtituloInSecondTap;
  final String Function(dynamic) obtenerSubFourdtituloInSecondTap;
  final String Function(dynamic) obtenerSubFivetituloInSecondTap;

  final TextStyle styleTitulo;
  final TextStyle styleSubTitulo;
  final TextStyle styleSubSecondtitulo;
  final Color iconWidgetColor;
  final double itemHeight;

  const TabSectionWidgetsdf({
    Key key,
    @required this.iconPrimerTap,
    @required this.itemHeight,
    @required this.iconSecondTap,
    @required this.namePrimerTap,
    @required this.nameSecondTap,
    @required this.listPrimerTap,
    @required this.listSecondTap,
    @required this.methodPrimerTap,
    @required this.methodSecondTap,
    @required this.primerIconWiget,
    @required this.obtenerSecondIconWigetInPrimerTap,
    @required this.obtenerSecondIconWigetInSecondTap,
    @required this.obtenerTituloInPrimerTap,
    @required this.obtenerSubTituloInPrimerTap,
    @required this.obtenerSubSecondtituloInPrimerTap,
    @required this.obtenerTituloInSecondTap,
    @required this.obtenerSubTituloInSecondTap,
    @required this.obtenerSubSecondtituloInSecondTap,
    @required this.styleTitulo,
    @required this.styleSubTitulo,
    @required this.styleSubSecondtitulo,
    @required this.iconWidgetColor,
    this.methodCodeSecondTap,
    this.methodCodePrimerTap,
    this.obtenerSubThirdtituloInPrimerTap,
    this.obtenerSubFourdtituloInPrimerTap,
    this.obtenerSubThirdtituloInSecondTap,
    this.obtenerSubFourdtituloInSecondTap,
    this.obtenerSubFivetituloInPrimerTap,
    this.obtenerSubFivetituloInSecondTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.8))),
            child: TabBar(
                indicatorColor: StylesThemeData.PRIMARY_COLOR,
                labelColor: StylesThemeData.PRIMARY_COLOR,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(iconPrimerTap),
                          SizedBox(width: 20, height: 50),
                          Text(namePrimerTap)
                        ]),
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Icon(iconSecondTap),
                        SizedBox(width: 20, height: 50),
                        Text(nameSecondTap)
                      ])),
                ]),
          ),
          Expanded(
            child: TabBarView(children: [
              Container(
                child: listPrimerTap == null
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadingGet(),
                      ))
                    : listPrimerTap.isEmpty
                        ? sinResultados("No se han encontrado resultados",
                            IconsData.ICON_ERROR_EMPTY)
                        : ListView.builder(
                            itemCount: listPrimerTap.length,
                            itemBuilder: (context, i) => ItemWidget(
                                  iconPrimary: primerIconWiget,
                                  itemHeight: itemHeight,
                                  iconSend:
                                      obtenerSecondIconWigetInPrimerTap != null
                                          ? obtenerSecondIconWigetInPrimerTap(i)
                                          : null,
                                  itemIndice: i,
                                  methodAction: methodPrimerTap,
                                  colorItem: i % 2 == 0
                                      ? StylesThemeData.ITEM_UNSHADED_COLOR
                                      : StylesThemeData.ITEM_SHADED_COLOR,
                                  titulo: obtenerTituloInPrimerTap != null
                                      ? obtenerTituloInPrimerTap(i)
                                      : null,
                                  subtitulo: obtenerSubTituloInPrimerTap != null
                                      ? obtenerSubTituloInPrimerTap(i)
                                      : null,
                                  subSecondtitulo:
                                      obtenerSubSecondtituloInPrimerTap != null
                                          ? obtenerSubSecondtituloInPrimerTap(i)
                                          : null,
                                  onPressedCode: methodCodePrimerTap,
                                  subThirdtitulo:
                                      obtenerSubThirdtituloInPrimerTap != null
                                          ? obtenerSubThirdtituloInPrimerTap(i)
                                          : null,
                                  subFourtitulo:
                                      obtenerSubFourdtituloInPrimerTap != null
                                          ? obtenerSubFourdtituloInPrimerTap(i)
                                          : null,
                                  subFivetitulo:
                                      obtenerSubFivetituloInPrimerTap != null
                                          ? obtenerSubFivetituloInPrimerTap(i)
                                          : null,
                                  iconSubSecondtitulo: null,
                                  styleTitulo: styleTitulo,
                                  styleSubTitulo: styleSubTitulo,
                                  styleSubSecondtitulo: styleSubSecondtitulo,
                                  iconColor: iconWidgetColor,
                                )),
              ),
              Container(
                child: listSecondTap == null
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadingGet(),
                      ))
                    : listSecondTap.isEmpty
                        ? sinResultados("No se han encontrado resultados",
                            IconsData.ICON_ERROR_EMPTY)
                        : ListView.builder(
                            itemCount: listSecondTap.length,
                            itemBuilder: (context, i) => ItemWidget(
                                  iconPrimary: primerIconWiget,
                                  itemHeight: itemHeight,
                                  iconSend:
                                      obtenerSecondIconWigetInSecondTap != null
                                          ? obtenerSecondIconWigetInSecondTap(i)
                                          : null,
                                  itemIndice: i,
                                  methodAction: methodSecondTap,
                                  colorItem: i % 2 == 0
                                      ? StylesThemeData.ITEM_SHADED_COLOR
                                      : StylesThemeData.ITEM_UNSHADED_COLOR,
                                  titulo: obtenerTituloInSecondTap != null
                                      ? obtenerTituloInSecondTap(i)
                                      : null,
                                  subtitulo: obtenerSubTituloInSecondTap != null
                                      ? obtenerSubTituloInSecondTap(i)
                                      : null,
                                  subSecondtitulo:
                                      obtenerSubSecondtituloInSecondTap != null
                                          ? obtenerSubSecondtituloInSecondTap(i)
                                          : null,
                                  onPressedCode: methodCodeSecondTap,
                                  subThirdtitulo:
                                      obtenerSubThirdtituloInSecondTap != null
                                          ? obtenerSubThirdtituloInSecondTap(i)
                                          : null,
                                  subFourtitulo:
                                      obtenerSubFourdtituloInSecondTap != null
                                          ? obtenerSubFourdtituloInSecondTap(i)
                                          : null,
                                  subFivetitulo:
                                      obtenerSubFivetituloInSecondTap != null
                                          ? obtenerSubFivetituloInSecondTap(i)
                                          : null,
                                  iconSubSecondtitulo: null,
                                  styleTitulo: styleTitulo,
                                  styleSubTitulo: styleSubTitulo,
                                  styleSubSecondtitulo: styleSubSecondtitulo,
                                  iconColor: iconWidgetColor,
                                )),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
