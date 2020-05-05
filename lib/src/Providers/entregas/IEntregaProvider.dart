import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';

abstract class IEntregaProvider{

  Future<List<EntregaModel>> listarEntregaporUsuario();

  Future<List<RecorridoModel>> listarRecorridoUsuario();  

  Future<List<RecorridoModel>> listarRecorridoporNombre(String nombre);  

  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId);  

  Future<int> listarEnviosValidados(List<EnvioModel> enviosvalidados,int id);

  Future<EnvioModel> validarCodigoProvider(String codigo,int id);

  Future<List<TurnoModel>> listarTurnosByCodigoLote(String codigo){}

    Future<List<TurnoModel>> listarTurnosByCodigoLote2(String codigo){}


  Future<EnvioModel> listarValijaByCodigoLote(String codigo){}

  Future<bool> registrarLoteLote(List<EnvioModel> envios, int turnoID){}

}