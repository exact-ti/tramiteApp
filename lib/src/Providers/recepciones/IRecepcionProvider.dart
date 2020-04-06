import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IRecepcionProvider{


  Future<List<EnvioModel>> recepcionJumboProvider(String codigo);  

  Future<List<EnvioModel>> recepcionValijaProvider(String codigo);  

  Future<bool> registrarJumboProvider(String codigo, String codigopaquete);  

  Future<bool> registrarValijaProvider(String codigo, String codigopaquete);  

}