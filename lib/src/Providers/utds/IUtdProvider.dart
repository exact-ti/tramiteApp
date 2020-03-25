
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';

abstract class IUtdProvider{
  Future<List<UtdModel>> listarUtdsDelUsuarioAutenticado();
}