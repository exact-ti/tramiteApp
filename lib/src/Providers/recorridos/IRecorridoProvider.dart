import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';


abstract class IRecorridoProvider{


  Future<List<EnvioModel>> enviosEntregaProvider(String codigo,int recorridoId);  

  Future<List<EnvioModel>> enviosRecojoProvider(String codigo,int recorridoId);  

  Future<dynamic> registrarEntregaProvider(String codigo,int recorridoId, String codigopaquete);  

  Future<dynamic> registrarRecojoProvider(String codigo,int recorridoId, String codigopaquete);  

  Future<bool> registrarEntregaPersonalizadaProvider(String dni, String codigopaquete);  

  Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(String firma, String codigopaquete);  


  Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada();
}