
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IEnvioProvider{

  Future<bool> crearEnvioProvider(EnvioModel envio);



  //agencias
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario();  

  Future<List<EnvioModel>> listarEnviosActivosByUsuario();  


  Future<List<EnvioModel>> listarRecepcionesActivas();  

  Future<List<EnvioModel>> listarEnviosActivosByUsuario2();  


  Future<List<EnvioModel>> listarRecepcionesActivas2();  


}