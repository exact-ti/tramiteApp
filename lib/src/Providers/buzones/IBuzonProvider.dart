
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';

abstract class IBuzonProvider{
  Future<List<BuzonModel>> listarBuzonesDelUsuarioAutenticado();
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids);
}