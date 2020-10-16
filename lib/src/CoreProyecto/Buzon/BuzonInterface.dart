import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';

abstract class BuzonInterface {
  
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids);

  Future<List<BuzonModel>> listarBuzones();

}