import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';

class EntregaInterface {

    
    Future<List<EntregaModel>> listarEntregas(){}

    Future<List<RecorridoModel>> listarRecorridosUsuario(){}

    Future<List<RecorridoModel>> listarRecorridosporNombre(String nombre){}

    Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId){}

    Future<int> listarEnviosValidados(List<EnvioModel> envios,int id){}

    Future<EnvioModel> validarCodigo(String codigo, int id){}
    }


