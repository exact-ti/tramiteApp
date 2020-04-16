import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class IAgenciasExternasInterface {
  Future<List<EnvioInterSedeModel>> listarEnviosAgenciasUsuario() {}

  Future<List<EnvioModel>> listarEnviosAgenciasByCodigo(
       String codigo) {}

  Future<EnvioModel> validarCodigoAgencia(String codigo, int id) {}

  Future<int> listarEnviosAgenciasValidados(
      List<EnvioModel> envios, String codigo) {}

  Future<bool> iniciarEntregaAgencia(int utdDestino) {}

}
