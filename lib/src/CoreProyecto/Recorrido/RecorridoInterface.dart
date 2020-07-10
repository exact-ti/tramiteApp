import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Listar-TipoPersonalizada/ListarTipoPersonalizadaPage.dart';

class RecorridoInterface {

    

    Future<List<EnvioModel>> enviosCoreRecojo(String codigo, int recorridoId){}

    Future<dynamic> enviosCoreEntrega(String codigo, int recorridoId){}

    Future<dynamic> registrarRecorridoRecojoCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion){}

    Future<dynamic> registrarRecorridoEntregaCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion){}

    Future<bool> registrarEntregaPersonalizadaProvider(String dni, String codigopaquete){}  

    Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(dynamic firma, String codigopaquete){}  


    Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada(){}

    }


