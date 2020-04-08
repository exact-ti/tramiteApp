
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/impl/PaqueteExternoProvider.dart';

class ImportarArchivoController {
  
  BuzonInterface buzon = new BuzonImpl(new BuzonProvider());
  PaqueteExternoInterface paqueteExterno = new PaqueteExternoImpl(new PaqueteExternoProvider());

  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    List<BuzonModel> buzonModelList = await buzon.listarBuzonesPorIds(ids);
    return buzonModelList;
  }

  Future<bool> importarPaquetesExternos(List<PaqueteExterno> paqueteExternoList, TipoPaqueteModel tipoPaquete) async {
    bool resp = await paqueteExterno.importarPaquetesExternos(paqueteExternoList, tipoPaquete);
    return resp;
  }

}