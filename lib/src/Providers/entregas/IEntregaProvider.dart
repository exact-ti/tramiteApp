import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';

abstract class IEntregaProvider{

  Future<List<EntregaModel>> listarEntregaporUsuario();

  Future<List<RecorridoModel>> listarRecorridoUsuario();  

  Future<List<RecorridoModel>> listarRecorridoporNombre(String nombre);  

  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId);  

  Future<int> listarEnviosValidados(List<EnvioModel> enviosvalidados,int id);

  Future<EnvioModel> validarCodigoProvider(String codigo,int id);

}