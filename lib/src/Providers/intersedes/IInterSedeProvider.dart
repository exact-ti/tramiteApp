import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IInterSedeProvider {
  Future<List<EnvioInterSedeModel>> listarEnvioByUsuario();

  Future<List<EnvioInterSedeModel>> listarRecepcionByUsuario();


  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo);

  Future<dynamic> listarRecepcionByCodigo(String codigo);

  Future<EnvioModel> validarCodigoProvider(String codigo, String codigobandeja);

  Future<dynamic> listarEnviosValidadosInterSede(
      List<EnvioModel> enviosvalidados, String codigo);

  Future<bool> iniciarEntregaIntersede(EnvioInterSedeModel entregaModel);

  Future<dynamic> registrarRecojoIntersedeProvider(
      String codigo, String codigopaquete);
}
