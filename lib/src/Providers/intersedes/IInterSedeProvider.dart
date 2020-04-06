import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IInterSedeProvider{

    Future<List<EnvioInterSedeModel>> listarEnvioByUsuario();  

    Future<List<EnvioModel>> listarEnviosByCodigo(EnvioInterSedeModel interSedeModel, String codigo);  


}