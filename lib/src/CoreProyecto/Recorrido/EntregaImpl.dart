import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/IRecorridoProvider.dart';
import 'RecorridoInterface.dart';

class RecorridoImpl implements RecorridoInterface {
  IRecorridoProvider recorrido;

  RecorridoImpl(IRecorridoProvider recorrido) {
    this.recorrido = recorrido;
  }

  @override
  Future<List<EnvioModel>> enviosCoreRecojo(
      String codigo, int recorridoId) async {
    List<EnvioModel> envios = new List();
      envios = await recorrido.enviosRecojoProvider(codigo, recorridoId);
    return envios;
  }

  @override
  Future<dynamic> enviosCoreEntrega(
      String codigo, int recorridoId) async {
      dynamic envios = await recorrido.enviosEntregaProvider(codigo, recorridoId);
    return envios;
  }


    @override
  Future<dynamic> registrarRecorridoEntregaCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion) async {
    dynamic respuesta = await recorrido.registrarEntregaProvider(
          codigoArea, recorridoId, codigoPaquete);
    return respuesta;      
  }

  @override
  Future<dynamic> registrarRecorridoRecojoCore(String codigoArea, int recorridoId,
      String codigoPaquete, bool opcion) async {
    
      dynamic respuesta = await recorrido.registrarRecojoProvider(
          codigoArea, recorridoId, codigoPaquete);

    return respuesta;
  }

  @override
  Future<bool> registrarEntregaPersonalizadaProvider(
      String dni, String codigopaquete) async {
    bool respuesta = await recorrido.registrarEntregaPersonalizadaProvider(
        dni, codigopaquete);
    return respuesta;
  }

  @override
  Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada() async  {
    return await recorrido.listarTipoPersonalizada();
  }

  @override
  Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(firma, String codigopaquete) async {
       dynamic respuesta = await recorrido.registrarEntregaPersonalizadaFirmaProvider(
        firma, codigopaquete);
    return respuesta;
  }


}
