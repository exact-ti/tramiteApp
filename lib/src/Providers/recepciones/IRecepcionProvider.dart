import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IRecepcionProvider {
  Future<dynamic> recepcionJumboProvider(String codigo,int utdId);

  Future<List<EnvioModel>> recepcionValijaProvider(String codigo);

  Future<bool> registrarJumboProvider(String codigo, String codigopaquete);

  Future<bool> registrarEnvioProvider(String codigopaquete);

  Future<bool> registrarValijaProvider(String codigo, String codigopaquete);

  Future<List<EnvioModel>> listarenvios();

  Future<List<EnvioModel>> listarenviosPrincipal();


  Future<bool> registrarListaEnvioPrincipalProvider(
      List<String> codigospaquetes);

  Future<dynamic> recibirJumboProvider(String codigoLote, String codigoPaquete);
}
