
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';

abstract class IBuzonProvider{
  Future<List<BuzonModel>> listarBuzonesDelUsuarioAutenticado();
}