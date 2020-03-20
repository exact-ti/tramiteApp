
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';

abstract class IConfiguracionProvider{
  Future<List<ConfiguracionModel>> listarConfiguraciones();
}