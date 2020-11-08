import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/impl/PaqueteExternoProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class CustodiaController {
  PaqueteExternoInterface paqueteExterno =
      new PaqueteExternoImpl(new PaqueteExternoProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    List<PaqueteExterno> tipoPaqueteList =
        await paqueteExterno.listarPaquetesExternosCreados();
    return tipoPaqueteList;
  }

  Future<bool> custodiarPaquete(String paquete) async {
    _navigationService.showModal();
    bool resp = await paqueteExterno.custodiarPaquete(paquete);
    _navigationService.goBack();
    return resp;
  }
}
