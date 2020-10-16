import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IConsultaProvider {
  Future<List<EnvioModel>> listarByPaqueteAndDestinatarioAndRemitente(
      String paquete, String destinatario, String remitente, bool opcion);
}
