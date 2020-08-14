import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/impl/PaqueteExternoProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ImportarArchivoController {
  BuzonInterface buzon = new BuzonImpl(new BuzonProvider());
  PaqueteExternoInterface paqueteExterno =
      new PaqueteExternoImpl(new PaqueteExternoProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    List<BuzonModel> buzonModelList = await buzon.listarBuzonesPorIds(ids);
    return buzonModelList;
  }

  Future<dynamic> importarPaquetesExternos(
      List<PaqueteExterno> paqueteExternoList,
      TipoPaqueteModel tipoPaquete) async {
    _navigationService.showModal();

    dynamic resp = await paqueteExterno.importarPaquetesExternos(
        paqueteExternoList, tipoPaquete);
    _navigationService.goBack();

    return resp;
  }
}
