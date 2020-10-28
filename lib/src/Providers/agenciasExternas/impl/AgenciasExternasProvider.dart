import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';

import '../IAgenciasExternasProvider.dart';

class AgenciaExternaProvider implements IAgenciaExternaProvider {
  Requester req = Requester();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciaByUsuario() async {
    int utdId = obtenerUTDid();
    Response resp =
        await req.get('/servicio-tramite/utds/$utdId/gruposagencias/activos');
    return sedeModel.fromJsonlistarEntregas(resp.data);
  }

  @override
  Future<dynamic> listarEnviosAgenciaByCodigo(String codigo) async {
    int utdId = obtenerUTDid();
    Response resp = await req.get(
        '/servicio-tramite/utds/$utdId/tipospaquetes/$valijaExternaId/paquetes/$codigo/envios');
    return resp.data;
  }

  @override
  Future<EnvioModel> validarCodigoAgenciaProvider(
      String bandeja, String codigo) async {
    try {
      Response resp = await req.get(
          '/servicio-tramite/tipospaquetes/valijas-agencia/$bandeja/paquetes/$codigo');
      if (resp.data == "") return null;
      return envioModel.fromOneJson(resp.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> listarEnviosAgenciaValidadosInterSede(
      List<EnvioModel> enviosvalidados, String codigo) async {
    int utdId = obtenerUTDid();
    List<int> ids = enviosvalidados.map((envio) => envio.id).toList();
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/valijas/$codigo/tiposentregas/$valijaExternaId/entregas',
        listaIds,
        null);
    return resp.data;
  }

  @override
  Future<bool> iniciarEntregaExternaIntersede(EnvioInterSedeModel envio) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/gruposagencias/${envio.utdId}/inicio',
        null,
        null);
    return resp.data ? true : false;
  }

  @override
  Future<bool> iniciarListaEntregaExternaIntersede(
      List<String> codigospaquetes) async {
    List<String> ids = new List();
    int utdId = obtenerUTDid();
    for (String envio in codigospaquetes) {
      ids.add(envio);
    }
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    final Map<String, dynamic> parametros = {
      "gruposAgenciasIds": gruposIds,
    };
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/inicio', null, parametros);
    return resp.data ? true : false;
  }
}
