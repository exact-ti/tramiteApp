import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IAgenciaExternaProvider{

    Future<List<EnvioInterSedeModel>> listarEnvioAgenciaByUsuario();  


    Future<List<EnvioModel>> listarEnviosAgenciaByCodigo(String codigo);  

    Future<EnvioModel> validarCodigoAgenciaProvider(String codigo,int id);

    Future<int> listarEnviosAgenciaValidadosInterSede(List<EnvioModel> enviosvalidados,String codigo);

    Future<bool> iniciarEntregaExternaIntersede(int utdDestino);  



}