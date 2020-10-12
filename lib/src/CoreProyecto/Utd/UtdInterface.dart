import 'package:tramiteapp/src/ModelDto/UtdModel.dart';

abstract class UtdInterface {
  

  Future<List<UtdModel>> listarUtds();

}