import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';

class EntregaInterface {

    
    Future<List<EntregaModel>> listarEntregas(){}

    Future<List<RecorridoModel>> listarRecorridosUsuario(){}

    Future<List<RecorridoModel>> listarRecorridosporNombre(String nombre){}

    Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId){}

    Future<int> listarEnviosValidados(List<EnvioModel> envios,int id){}

    Future<EnvioModel> validarCodigo(String codigo, int id){}

    Future<List<TurnoModel>> listarTurnosByCodigoLote(String codigo){}

    Future<EnvioModel> listarValijaByCodigoLote(String codigo){}

    Future<bool> registrarLoteLote(List<EnvioModel> envios, int turnoID, String codigo){}



    }


