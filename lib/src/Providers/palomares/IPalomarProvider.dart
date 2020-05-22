import 'package:tramiteapp/src/ModelDto/palomarModel.dart';

abstract class IPalomarProvider{
  Future<dynamic> listarPalomarByCodigo(String codigo);

  Future<PalomarModel> listarPalomarByCodigo2(String codigo);
}