import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';

class EnviosUTDController {
  EnvioInterface envioInterface = new EnvioImpl(
      new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());

  Future<List<EnvioModel>> listarUTDController() async {
    List<EnvioModel> entregas = await envioInterface.listarEnviosUTD();
    return entregas;
  }

}
