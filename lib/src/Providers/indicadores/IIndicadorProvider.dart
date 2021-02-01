import 'package:tramiteapp/src/ModelDto/Indicador.dart';

abstract class IIndicadorProvider {
  
  Future<List<Indicador>> listIndicador();

}
