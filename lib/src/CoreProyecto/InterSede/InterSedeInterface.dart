import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class InterSedeInterface {

    Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(){}

    Future<List<EnvioModel>> listarEnviosByCodigo(EnvioInterSedeModel envioInterSedeModel,String codigo){}

    }


