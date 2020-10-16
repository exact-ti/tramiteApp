import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class ConsultaInterface {
  
  Future<List<EnvioModel>> consultarByPaqueteAndDestinatarioAndRemitente(String paquete,String remitente,String destinatario,bool opcion);

}