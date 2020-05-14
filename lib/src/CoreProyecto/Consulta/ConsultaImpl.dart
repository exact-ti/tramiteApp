
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/consultas/IConsultaProvider.dart';

import 'ConsultaInterface.dart';

class ConsultaImpl implements ConsultaInterface {

  IConsultaProvider consultaProvider;

  ConsultaImpl(IConsultaProvider consultaProvider){
    this.consultaProvider = consultaProvider;
  }

  @override
  Future<List<EnvioModel>> consultarByPaqueteAndDestinatarioAndRemitente(String paquete, String remitente, String destinatario,bool opcion) async {
    List<EnvioModel> envios = await consultaProvider.listarByPaqueteAndDestinatarioAndRemitente2(paquete, destinatario, remitente,opcion);
    return envios;
  }
}