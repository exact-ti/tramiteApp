import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class EnvioProvider implements IEnvioProvider {
  Requester req = Requester();

  ConfiguracionModel configuracionmodel = new ConfiguracionModel();
  final _prefs = new PreferenciasUsuario();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();
  UtdModel utdModel = new UtdModel();
  BuzonModel buzonModel = new BuzonModel();
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

  //agencias
  @override
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciasByUsuario() async {
    int utdId = obtenerUTDid();
    Response resp =
        await req.get('/servicio-tramite/utds/$utdId/utdsparaentrega');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio = sedeModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<EnvioModel>> listarEnviosActivosByUsuario(
      List<int> estadosids) async {
    List<String> ids = new List();
    estadosids.forEach((element) {
      ids.add("$element");
    });
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/salida?etapasIds=$gruposIds');
    if (resp.data == "") {
      return null;
    }
    dynamic respuesta = resp.data;
    List<dynamic> envio = respuesta["data"];
    List<EnvioModel> enviosMode = envioModel.fromEnviadosActivos(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> listarRecepcionesActivas(
      List<int> estadosids) async {
    List<String> ids = new List();
    estadosids.forEach((element) {
      ids.add("$element");
    });
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/entrada?etapasIds=$gruposIds');
    if (resp.data == "") {
      return null;
    }
    dynamic respuesta = resp.data;
    List<dynamic> envio = respuesta["data"];
    List<EnvioModel> enviosMode = envioModel.fromEnviadosActivos(envio);
    return enviosMode;
  }

  @override
  Future<List<EstadoEnvio>> listarEstadosEnvios() async {
    Response resp =
        await req.get('/servicio-tramite/etapasenvios?incluirHistoricos=false');
    dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<EstadoEnvio> listEstados =
        estadoEnvio.fromJsonToEnviosActivos(respdatalist);
    return listEstados;
  }

  @override
  Future<List<EnvioModel>> listarEnviosUTD() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/envios');
    dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<EnvioModel> listEstados = envioModel.fromEnviosUTD(respdatalist);
    return listEstados;
  }

  @override
  Future<List<EnvioModel>> listarEnviosHistoricosEntrada(
      String fechaInicio, String fechaFin) async {
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/entrada?etapasIds=5&desde=$fechaInicio&hasta=$fechaFin');
    dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<EnvioModel> listEstados = envioModel.fromEnviosUTD(respdatalist);
    return listEstados;
  }

  @override
  Future<List<EnvioModel>> listarEnviosHistoricosSalida(
      String fechaInicio, String fechaFin) async {
    int buzonId = obtenerBuzonid();
    Response resp = await req.get(
        '/servicio-tramite/buzones/$buzonId/envios/salida?etapasIds=5&desde=$fechaInicio&hasta=$fechaFin');
    dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<EnvioModel> listEstados = envioModel.fromEnviosUTD(respdatalist);
    return listEstados;
  }

  @override
  Future<dynamic> retirarEnvioProvider(
      EnvioModel envioModel, String motivo) async {
    String envioId = envioModel.id.toString();
    final Map<String, dynamic> parametros = {
      "motivo": motivo,
    };
    Response resp = await req.put(
        "/servicio-tramite/envios/$envioId/retiro", null, parametros);
    dynamic respuestaData = resp.data;
    return respuestaData;
  }
}
