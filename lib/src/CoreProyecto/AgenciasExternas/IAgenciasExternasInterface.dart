import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IAgenciasExternasInterface {
  Future<List<EnvioInterSedeModel>> listarEnviosAgenciasUsuario();

  Future<dynamic> listarEnviosAgenciasByCodigo(String codigo);

  Future<EnvioModel> validarCodigoAgencia(String bandeja, String codigo);

  Future<int> listarEnviosAgenciasValidados(
      List<EnvioModel> envios, String codigo);

  Future<bool> iniciarEntregaAgencia(EnvioInterSedeModel envio);

  Future<bool> iniciarEntregaListaAgencia(List<String> listaCodigos);

 Future<List<EnvioModel>>  listarEnviosAgenciasToCustodia();  

     Future<dynamic> custodiarPaquete(String paqueteId);  


}
