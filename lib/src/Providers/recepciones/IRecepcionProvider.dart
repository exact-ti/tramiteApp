import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IRecepcionProvider{


  Future<List<EnvioModel>> recepcionJumboProvider(String codigo);  

  Future<List<EnvioModel>> recepcionValijaProvider(String codigo);  

  Future<bool> registrarJumboProvider(String codigo, String codigopaquete);  

  Future<bool> registrarEnvioProvider(String codigopaquete);  


  Future<bool> registrarValijaProvider(String codigo, String codigopaquete);  

  Future<List<EnvioModel>> listarenvios();  

  Future<List<EnvioModel>> listarenviosPrincipal();  

  Future<List<EnvioModel>> listarenviosPrincipal2();  

  Future<bool> registrarEnvioPrincipalProvider(String codigopaquete);  

  Future<bool> registrarListaEnvioPrincipalProvider(List<String> codigospaquetes);  



}