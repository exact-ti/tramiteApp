
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

abstract class IEnvioProvider{

  void crearEnvioProvider(EnvioModel envio);



  //agencias
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario();  


}