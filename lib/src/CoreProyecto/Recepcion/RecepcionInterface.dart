import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class RecepcionInterface {
  Future<dynamic> listarEnviosByLote(String codigo);

  Future<List<EnvioModel>> listarEnviosCore();

  Future<List<EnvioModel>> listarEnviosPrincipalCore();

  Future<bool> registrarRecorridoCore(String codigoArea, String codigoPaquete);

  Future<bool> registrarLote(String codigoArea, String codigoPaquete);

  Future<dynamic> recibirLote(String codigoLote, String codigoValija);

  Future<bool> registrarEnvioCore(String codigoPaquete);

  Future<bool> registrarListaEnvioPrincipalCore(List<String> codigosPaquete);
}
