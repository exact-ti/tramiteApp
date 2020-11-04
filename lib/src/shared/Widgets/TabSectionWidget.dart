import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class TabSectionWidget extends StatelessWidget {
  final IconData iconPrimerTap;
  final IconData iconSecondTap;
  final String namePrimerTap;
  final String nameSecondTap;
  final List<dynamic> listPrimerTap;
  final List<dynamic> listSecondTap;
  final ValueChanged<dynamic> methodPrimerTap;
  final ValueChanged<dynamic> methodSecondTap;
  final IconData primerIconWiget;
  final IconData Function(dynamic) obtenerSecondIconWigetInPrimerTap;
  final IconData Function(dynamic) obtenerSecondIconWigetInSecondTap;
  final String Function(dynamic) obtenerTituloInPrimerTap;
  final String Function(dynamic) obtenerSubTituloInPrimerTap;
  final String Function(dynamic) obtenerSubSecondtituloInPrimerTap;
  final String Function(dynamic) obtenerTituloInSecondTap;
  final String Function(dynamic) obtenerSubTituloInSecondTap;
  final String Function(dynamic) obtenerSubSecondtituloInSecondTap;
  final TextStyle styleTitulo;
  final TextStyle styleSubTitulo;
  final TextStyle styleSubSecondtitulo;
  final Color iconWidgetColor;

  const TabSectionWidget({
    Key key,
    @required this.iconPrimerTap,
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
                        ? sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY)
                        : ListView.builder(
                            itemCount: listPrimerTap.length,
                            itemBuilder: (context, i) => ItemWidget(
                                  iconPrimary: primerIconWiget,
                                  iconSend:
                                      obtenerSecondIconWigetInPrimerTap(i),
                                  itemIndice: i,
                                  methodAction: methodPrimerTap,
                                  colorItem: i % 2 == 0
                                      ? StylesThemeData.ITEM_UNSHADED_COLOR
                                      : StylesThemeData.ITEM_SHADED_COLOR,
                                  titulo: obtenerTituloInPrimerTap(i),
                                  subtitulo: obtenerSubTituloInPrimerTap(i),
                                  subSecondtitulo:
                                      obtenerSubSecondtituloInPrimerTap(i),
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
                        ? sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY)
                        : ListView.builder(
                            itemCount: listSecondTap.length,
                            itemBuilder: (context, i) => ItemWidget(
                                  iconPrimary: primerIconWiget,
                                  iconSend:
                                      obtenerSecondIconWigetInSecondTap(i),
                                  itemIndice: i,
                                  methodAction: methodSecondTap,
                                  colorItem: i % 2 == 0
                                      ? StylesThemeData.ITEM_SHADED_COLOR
                                      : StylesThemeData.ITEM_UNSHADED_COLOR,
                                  titulo: obtenerTituloInSecondTap(i),
                                  subtitulo: obtenerSubTituloInSecondTap(i),
                                  subSecondtitulo:
                                      obtenerSubSecondtituloInSecondTap(i),
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
