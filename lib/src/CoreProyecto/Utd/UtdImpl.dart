import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/utds/IUtdProvider.dart';
import 'UtdInterface.dart';

class UtdImpl implements UtdInterface {

  IUtdProvider utdProvider;

  UtdImpl(IUtdProvider utdProvider){
    this.utdProvider = utdProvider;
  }

  @override
  Future<List<UtdModel>> listarUtds() async {
    return await utdProvider.listarUtdsDelUsuarioAutenticado();
  }

}