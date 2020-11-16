import 'package:tramiteapp/src/CoreProyecto/Indicador/IIndicadorCore.dart';
import 'package:tramiteapp/src/CoreProyecto/Indicador/IndicadorCore.dart';
import 'package:tramiteapp/src/ModelDto/Indicador.dart';
import 'package:tramiteapp/src/Providers/indicadores/impl/IndicadorProvider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tramiteapp/src/Util/utils.dart';

class DashboardOperacionController {
  IIndicadorCore indicadorCore = new IndicadorCore(new IndicadorProvider());
  List<charts.Series<Indicador, String>> _seriesPieData = new List();
  List<charts.Series<Indicador, String>> seriesData = new List();

  Future<List<Indicador>> listarDataIndicadores() async {
    List<Indicador> listIndicadores = await indicadorCore.listIndicadores();
    return listIndicadores;
  }

  List<charts.Series<Indicador, String>> indicadoresToSerieData(
      List<Indicador> listIndicadores) {
    seriesData.add(
      charts.Series(
        domainFn: (Indicador indicador, _) => indicador.nombre,
        measureFn: (Indicador indicador, _) => indicador.cantidad,
        id: 'serie data',
        data: listIndicadores,
/*         seriesColor:
            charts.ColorUtil.fromDartColor(StylesThemeData.PRIMARY_COLOR), */
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
/*         fillColorFn: (Indicador indicador, _) => charts.ColorUtil.fromDartColor(
            colorByEstadoDocumento(indicador.nombre)), */
      ),
    );
    return seriesData;
  }

  List<charts.Series<Indicador, String>> indicadoresToPieData(
      List<Indicador> listIndicadores) {
    if (listIndicadores.isEmpty) return [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (Indicador indicador, _) => indicador.nombre,
        measureFn: (Indicador indicador, _) =>
            porcentajePorIndicador(listIndicadores, indicador),
/*         colorFn: (Indicador indicador, _) => charts.ColorUtil.fromDartColor(
            colorByEstadoDocumento(indicador.nombre)), */
/*         seriesColor:
            charts.ColorUtil.fromDartColor(StylesThemeData.PRIMARY_COLOR), */
        id: 'pie data',
        data: listIndicadores.toList(),
        labelAccessorFn: (Indicador indicador, _) =>
            ('${porcentajePorIndicador(listIndicadores, indicador)} %'),
      ),
    );
    return _seriesPieData;
  }

  double porcentajePorIndicador(
      List<Indicador> listIndicadores, Indicador indicador) {
        double valorPorcentaje = (indicador.cantidad /
            listIndicadores
                .map((indicador) => indicador.cantidad)
                .reduce((a, b) => a + b)) *
        100;
    return redondearDouble(valorPorcentaje, 1) ;
  }
}
