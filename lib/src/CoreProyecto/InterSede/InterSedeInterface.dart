import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class InterSedeInterface {

    Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(){}

    Future<List<EnvioModel>> listarEnviosByCodigo(EnvioInterSedeModel envioInterSedeModel,String codigo){}

    Future<EnvioModel> validarCodigo(String codigo, int id){}

  Future<int> listarEnviosValidadosInterSede(List<EnvioModel> envios,int id,String codigo){}

    Future<bool> iniciarEntregaIntersede(int utdDestino){}  

    }


