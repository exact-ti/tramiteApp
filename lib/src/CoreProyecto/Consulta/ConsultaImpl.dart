
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/consultas/IConsultaProvider.dart';

import 'ConsultaInterface.dart';

class ConsultaImpl implements ConsultaInterface {

  IConsultaProvider consultaProvider;

  ConsultaImpl(IConsultaProvider consultaProvider){
    this.consultaProvider = consultaProvider;
  }

  @override
  Future<List<EnvioModel>> consultarByPaqueteAndDestinatarioAndRemitente(String paquete, String remitente, String destinatario,bool opcion) async {
    return await consultaProvider.listarByPaqueteAndDestinatarioAndRemitente(paquete, destinatario, remitente,opcion);
  }
}