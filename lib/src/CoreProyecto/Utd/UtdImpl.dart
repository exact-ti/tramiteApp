
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/utds/IUtdProvider.dart';

import 'UtdInterface.dart';

class UtdImpl implements UtdInterface {

  IUtdProvider utdProvider;

  UtdImpl(IUtdProvider utdProvider){
    this.utdProvider = utdProvider;
  }

  @override
  Future<List<UtdModel>> listarUtds() async {
  List<UtdModel> utds = await utdProvider.listarUtdsDelUsuarioAutenticado();
    return utds;
  }

}