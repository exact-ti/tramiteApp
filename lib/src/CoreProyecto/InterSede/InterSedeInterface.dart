import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class InterSedeInterface {
  Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(int switched) {}

  Future<List<EnvioModel>> listarEnviosByCodigo(
       String codigo) {}

  Future<List<EnvioModel>> listarRecepcionesByCodigo(
       String codigo) {}

  Future<EnvioModel> validarCodigo(String codigo, int id) {}

  Future<int> listarEnviosValidadosInterSede(
      List<EnvioModel> envios, String codigo) {}

  Future<bool> iniciarEntregaIntersede(int utdDestino) {}


  Future<bool> registrarRecojoIntersedeProvider(
      String codigo, EnvioInterSedeModel envio, String codigopaquete){} 
}
