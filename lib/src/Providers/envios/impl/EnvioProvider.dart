import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
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
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    final formData = json.encode({
      "remitenteId": id,
      "destinatarioId": envio.destinatarioId,
      "codigoPaquete": envio.codigoPaquete,
      "codigoUbicacion": envio.codigoUbicacion,
      "observacion": envio.observacion
    });

    try {
      Response resp = await req.post('/servicio-tramite/envios', formData, null);
      if (resp.data != null  || resp.data !="") {
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
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/utdsparaentrega');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio = sedeModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<EnvioModel>> listarEnviosActivosByUsuario(List<int> estadosids) async {
    List<String> ids = new List();
    estadosids.forEach((element) {
      ids.add("$element");
      });
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp =await req.get('/servicio-tramite/buzones/$id/envios/activos/salida?estadosIds=$gruposIds');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromEnviadosActivos(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> listarRecepcionesActivas(List<int> estadosids) async {
    List<String> ids = new List();
    estadosids.forEach((element) {
      ids.add("$element");
      });
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp =await req.get('/servicio-tramite/buzones/$id/envios/activos/entrada?estadosIds=$gruposIds');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromEnviadosActivos(envio);
    return enviosMode;
  }

  @override
  Future<List<EstadoEnvio>> listarEstadosEnvios() async {
    Response resp = await req.get('/servicio-tramite/etapasenvios?incluirHistoricos=false');
    dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<EstadoEnvio> listEstados = estadoEnvio.fromJsonToEnviosActivos(respdatalist);
    return listEstados;
  }
}
