import 'package:tramiteapp/src/ModelDto/palomarModel.dart';

abstract class IPalomarProvider{
  Future<PalomarModel> listarPalomarByCodigo(String codigo);

  Future<PalomarModel> listarPalomarByCodigo2(String codigo);
}