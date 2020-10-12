import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class InterSedeInterface {
  Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(int switched);

  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo);

  Future<List<EnvioModel>> listarRecepcionesByCodigo(String codigo);

  Future<EnvioModel> validarCodigo(String codigo, String codigovalija);

  Future<dynamic> listarEnviosValidadosInterSede(
      List<EnvioModel> envios, String codigo);

  Future<bool> iniciarEntregaIntersede(int utdDestino);

  Future<dynamic> registrarRecojoIntersedeProvider(
      String codigo, String codigopaquete);
}
