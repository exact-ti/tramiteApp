
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';

abstract class IEnvioProvider{

  Future<bool> crearEnvioProvider(EnvioModel envio);

  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario();  

  Future<List<EnvioModel>> listarEnviosActivosByUsuario(List<int> estadosids);  

  Future<List<EnvioModel>> listarRecepcionesActivas(List<int> estadosids);  

  Future<List<EstadoEnvio>> listarEstadosEnvios();  

  Future<List<EnvioModel>> listarEnviosUTD();  

  Future<List<EnvioModel>> listarEnviosHistoricosEntrada(String fechaInicio,String fechaFin);

  Future<List<EnvioModel>> listarEnviosHistoricosSalida(String fechaInicio,String fechaFin); 

  Future<dynamic> retirarEnvioProvider(String envioModelId,String motivo);
}