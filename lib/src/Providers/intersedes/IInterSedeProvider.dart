import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IInterSedeProvider{

    Future<List<EnvioInterSedeModel>> listarEnvioByUsuario();  

    Future<List<EnvioInterSedeModel>> listarRecepcionesByUsuario();  

    Future<List<EnvioModel>> listarEnviosByCodigo(String codigo);  

    Future<List<EnvioModel>> listarRecepcionByCodigo(String codigo);  


    Future<EnvioModel> validarCodigoProvider(String codigo,String codigobandeja);

    Future<int> listarEnviosValidadosInterSede(List<EnvioModel> enviosvalidados,String codigo);

    Future<bool> iniciarEntregaIntersede(int utdDestino);  

     Future<bool> registrarRecojoIntersedeProvider(
      String codigo, String codigopaquete);


}