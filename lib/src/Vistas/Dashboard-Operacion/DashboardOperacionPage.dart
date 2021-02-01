import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/Indicador.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Dashboard-Operacion/DashboardOperacionController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/TabSectionWidget.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardOperacionPage extends StatefulWidget {
  @override
  _DashboardOperacionPageState createState() => new _DashboardOperacionPageState();
}

class _DashboardOperacionPageState extends State<DashboardOperacionPage> {
  DashboardOperacionController homeController = new DashboardOperacionController();
  List<charts.Series<Indicador, String>> _seriesData;
  List<charts.Series<Indicador, String>> _seriesPieData;
  List<Indicador> listIndicadores;
  bool animate = true;

  @override
  void initState() {
    generateData();
    super.initState();
  }

  void generateData() async {
    listIndicadores = await homeController.listarDataIndicadores();
    if (this.mounted) {
      setState(() {
        _seriesData = homeController.indicadoresToSerieData(listIndicadores);
        _seriesPieData = homeController.indicadoresToPieData(listIndicadores);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget generarPrimerTap() {
      return _seriesPieData == null
          ? null
          : _seriesPieData.isEmpty? sinResultados("No hay envíos activos", IconsData.ICON_ERROR_EMPTY):Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                          child: Text(
                        'Estados de los documentos en UTD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Expanded(
                      child: charts.PieChart(_seriesPieData,
                          animate: animate,
                          animationDuration: Duration(seconds: 1),
                          behaviors: [
                            new charts.DatumLegend(
                              outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding:
                                  new EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 11),
                            ),
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                              arcWidth: 100,
                              arcRendererDecorators: [
                                new charts.ArcLabelDecorator(
                                    labelPosition:
                                        charts.ArcLabelPosition.inside)
                              ])),
                    ),
                  ],
                ),
              ),
            );
    }

    Widget generarSecondTap() {
      return _seriesData == null
          ? null
          : _seriesData.isEmpty? sinResultados("No hay envíos activos", IconsData.ICON_ERROR_EMPTY): Container(
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                            child: Text(
                          'Estados de los documentos en UTD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        )),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: animate,
                          barGroupingType: charts.BarGroupingType.grouped,
                          //behaviors: [new charts.SeriesLegend()],
                          animationDuration: Duration(seconds: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Dashboard operación"),
        drawer: DrawerPage(),
        body: TabSectionWidget(
            iconPrimerTap: Icons.data_usage,
            iconSecondTap: Icons.border_all,
            namePrimerTap: "Diagrama pie",
            nameSecondTap: "Barras",
            itemPrimerTapWidget: generarPrimerTap(),
            itemSecondTapWidget: generarSecondTap()));
  }
}
