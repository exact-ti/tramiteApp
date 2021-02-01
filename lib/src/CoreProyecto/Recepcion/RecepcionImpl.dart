import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/IRecepcionProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'RecepcionInterface.dart';

class RecepcionImpl implements RecepcionInterface {
  IRecepcionProvider recepcion;

  RecepcionImpl(IRecepcionProvider recepcion) {
    this.recepcion = recepcion;
  }

  @override
  Future listarEnviosByLote(String codigo) async {
    int utdId = obtenerUTDid();
    return await recepcion.recepcionJumboProvider(codigo, utdId);
  }

  @override
  Future<bool> registrarRecorridoCore(
      String codigoArea, String codigoPaquete) async {
    return await recepcion.registrarJumboProvider(codigoArea, codigoPaquete);
  }

  @override
  Future<List<EnvioModel>> listarEnviosCore() async {
    return await recepcion.listarenvios();
  }

  @override
  Future<bool> registrarEnvioCore(String codigoPaquete) async {
    return await recepcion.registrarEnvioProvider(codigoPaquete);
  }

  @override
  Future<List<EnvioModel>> listarEnviosPrincipalCore() async {
    return await recepcion.listarenviosPrincipal();
  }

  @override
  Future<bool> registrarListaEnvioPrincipalCore(
      List<String> codigosPaquete) async {
    return await recepcion.registrarListaEnvioPrincipalProvider(codigosPaquete);
  }

  @override
  Future<bool> registrarLote(String codigoArea, String codigoPaquete) async {
    return await recepcion.registrarJumboProvider(codigoArea, codigoPaquete);
  }

  @override
  Future<dynamic> recibirLote(String codigoLote, String codigoPaquete) async {
    return await recepcion.recibirJumboProvider(codigoLote, codigoPaquete);
  }
}
