
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';

abstract class IEnvioProvider{

  Future<bool> crearEnvioProvider(EnvioModel envio);



  //agencias
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario();  

  Future<List<EnvioModel>> listarEnviosActivosByUsuario(List<int> estadosids);  


  Future<List<EnvioModel>> listarRecepcionesActivas(List<int> estadosids);  

  Future<List<EstadoEnvio>> listarEstadosEnvios();  


}