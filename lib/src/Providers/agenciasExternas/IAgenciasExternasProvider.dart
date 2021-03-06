import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IAgenciaExternaProvider{

    Future<List<EnvioInterSedeModel>> listarEnvioAgenciaByUsuario();  

    Future<dynamic> listarEnviosAgenciaByCodigo(String codigo);  

    Future<EnvioModel> validarCodigoAgenciaProvider(String bandeja,String codigo);

    Future<int> listarEnviosAgenciaValidadosInterSede(List<EnvioModel> enviosvalidados,String codigo);

    Future<bool> iniciarEntregaExternaIntersede(EnvioInterSedeModel envio);  

    Future<bool> iniciarListaEntregaExternaIntersede(List<String> codigospaquetes);  

    Future<List<EnvioModel>> listarEnviosAgenciasToCustodia(int utdId);  
    
    Future<dynamic> custodiarPaquete(String paqueteId,int utdId);  
}