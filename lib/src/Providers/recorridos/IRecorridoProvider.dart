import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';


abstract class IRecorridoProvider{


  Future<List<EnvioModel>> enviosEntregaProvider(String codigo,int recorridoId);  

  Future<List<EnvioModel>> enviosRecojoProvider(String codigo,int recorridoId);  

  Future<bool> registrarEntregaProvider(String codigo,int recorridoId, String codigopaquete);  

  Future<dynamic> registrarRecojoProvider(String codigo,int recorridoId, String codigopaquete);  

  Future<bool> registrarEntregaPersonalizadaProvider(String dni,int recorridoId, String codigopaquete);  


}