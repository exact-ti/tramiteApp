import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';

class EnvioProvider implements IEnvioProvider {
  Requester req = Requester();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();
  EstadoEnvio estadoEnvio = new EstadoEnvio();

  @override
  Future<bool> crearEnvioProvider(EnvioModel envio) async {
    int buzonId = obtenerBuzonid();
    final formData = json.encode({
      "remitenteId": buzonId,
      "destinatarioId": envio.destinatarioId,
      "codigoPaquete": envio.codigoPaquete,
      "codigoUbicacion": envio.codigoUbicacion,
      "observacion": envio.observacion
    });

    try {
      Response resp =
          await req.post('/servicio-tramite/envios', formData, null);
      if (resp.data != null || resp.data != "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/utdsparaentrega');
    return sedeModel.fromJsonValidar(resp.data);
  }

  @override
  Future<List<EnvioModel>> listarEnviosActivosByUsuario(
      List<int> estadosids) async {
    List<String> ids = estadosids.map((estadoId) => "$estadoId").toList();
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/salida?etapasIds=$gruposIds');
    if (resp.data == "") return null;
    dynamic respuesta = resp.data;
    return envioModel.fromEnviadosActivos(respuesta["data"]);
  }

  @override
  Future<List<EnvioModel>> listarRecepcionesActivas(
      List<int> estadosids) async {
    List<String> ids = estadosids.map((estadoId) => "$estadoId").toList();
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/entrada?etapasIds=$gruposIds');
    if (resp.data == "") return null;
    dynamic respuesta = resp.data;
    return envioModel.fromEnviadosActivos(respuesta["data"]);
  }

  @override
  Future<List<EstadoEnvio>> listarEstadosEnvios() async {
    Response resp = await req.get('/servicio-tramite/etapasenvios?incluirHistoricos=false');
    dynamic respuestaData = resp.data;
    return estadoEnvio.fromJsonToEnviosActivos(respuestaData["data"]);
  }

  @override
  Future<List<EnvioModel>> listarEnviosUTD() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/envios');
    dynamic respuestaData = resp.data;
    return envioModel.fromEnviosUTD(respuestaData["data"]);
  }

  @override
  Future<List<EnvioModel>> listarEnviosHistoricosEntrada(
      String fechaInicio, String fechaFin) async {
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/entrada?etapasIds=5&desde=$fechaInicio&hasta=$fechaFin');
    dynamic respuestaData = resp.data;
    return envioModel.fromEnviosUTD(respuestaData["data"]);
  }

  @override
  Future<List<EnvioModel>> listarEnviosHistoricosSalida(
      String fechaInicio, String fechaFin) async {
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/salida?etapasIds=5&desde=$fechaInicio&hasta=$fechaFin');
    dynamic respuestaData = resp.data;
    return envioModel.fromEnviosUTD(respuestaData["data"]);
  }

  @override
  Future<dynamic> retirarEnvioProvider(
      String envioModelId, String motivo) async {
    final Map<String, dynamic> parametros = {
      "motivo": motivo,
    };
    Response resp = await req.put(
        "/servicio-tramite/envios/$envioModelId/retiro", null, parametros);
    return resp.data;
  }
}
