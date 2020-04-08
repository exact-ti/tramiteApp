import 'package:tramiteapp/src/ModelDto/palomarModel.dart';

abstract class IPalomarProvider{
  Future<PalomarModel> listarPalomarByCodigo(String codigo);
}