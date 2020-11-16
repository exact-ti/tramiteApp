
import 'package:tramiteapp/src/ModelDto/Indicador.dart';

import 'IIndicadorCore.dart';
import 'package:tramiteapp/src/Providers/indicadores/IIndicadorProvider.dart';

class IndicadorCore implements IIndicadorCore {

  IIndicadorProvider indicadorProvider;

  IndicadorCore(IIndicadorProvider indicadorProvider){
    this.indicadorProvider = indicadorProvider;
  }

  @override
  Future<List<Indicador>> listIndicadores() async {
    return await indicadorProvider.listIndicador();
  }
}