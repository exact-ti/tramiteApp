import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IConsultaProvider.dart';

class ConsultaProvider implements IConsultaProvider {
  Requester req = Requester();
  EnvioModel envioModel = new EnvioModel();
  @override
  Future<List<EnvioModel>> listarByPaqueteAndDestinatarioAndRemitente(String paquete,String destinatario,String remitente,bool opcion) async {
    Response resp = await req.get( '/servicio-tramite/envios?paqueteId=$paquete&remitente=$remitente&destinatario=$destinatario&incluirInactivos=$opcion');
    List<dynamic> envios = resp.data;
    if (envios.isEmpty) return [];
    return envioModel.fromJsonConsultaEnvio(envios);
  }
}
