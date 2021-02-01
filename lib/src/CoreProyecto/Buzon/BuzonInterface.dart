import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';

abstract class BuzonInterface {
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids);

  Future<List<BuzonModel>> listarBuzones();

  void changeBuzonById(int buzonId);

  BuzonModel listarBuzonPrincipal();

  BuzonModel listarBuzonById(int buzonId);

  String obtenerNombreBuzonById(int buzonId);
}
