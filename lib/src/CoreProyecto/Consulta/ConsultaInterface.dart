import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class ConsultaInterface {
  
  Future<List<EnvioModel>> consultarByPaqueteAndDestinatarioAndRemitente(String paquete,String remitente,String destinatario,bool opcion){}

}