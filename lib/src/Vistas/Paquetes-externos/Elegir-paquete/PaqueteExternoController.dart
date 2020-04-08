
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/impl/PaqueteExternoProvider.dart';

class PaqueteExternoController {

  PaqueteExternoInterface paqueteExterno = new PaqueteExternoImpl(new PaqueteExternoProvider());

  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno) async {
    List<TipoPaqueteModel> tipoPaqueteList = await paqueteExterno.listarPaquetesPorTipo(interno);
    return tipoPaqueteList;
  }

}