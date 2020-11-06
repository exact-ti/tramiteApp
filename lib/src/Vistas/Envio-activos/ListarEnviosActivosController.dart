import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';

class EnviosActivosController {
  EnvioInterface envioInterface = new EnvioImpl(
      new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());

  Future<List<EnvioModel>> listarActivosController(
      bool porRecibir, List<int> estadosids) async {
    List<EnvioModel> entregas = new List();
    if (estadosids.length == 0) {
      List<EstadoEnvio> estados = await envioInterface.listarEstadosEnvios();
      estados.forEach((element) {
        estadosids.add(element.id);
      });
      entregas = await envioInterface.listarActivos(porRecibir,estadosids);
    } else {
      entregas = await envioInterface.listarActivos(porRecibir,estadosids);
    }
    return entregas;
  }

  Future<List<EstadoEnvio>> listarEnviosEstados() async {
    List<EstadoEnvio> estados = await envioInterface.listarEstadosEnvios();
    return estados;
  }
}
