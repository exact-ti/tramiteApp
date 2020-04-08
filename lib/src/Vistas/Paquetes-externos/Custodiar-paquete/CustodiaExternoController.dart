
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/impl/PaqueteExternoProvider.dart';

class CustodiaController {

  PaqueteExternoInterface paqueteExterno = new PaqueteExternoImpl(new PaqueteExternoProvider());

  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    List<PaqueteExterno> tipoPaqueteList = await paqueteExterno.listarPaquetesExternosCreados();
    return tipoPaqueteList;
  }
}
