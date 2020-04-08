import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'dart:convert';

import '../IInterSedeProvider.dart';

class InterSedeProvider implements IInterSedeProvider {
  Requester req = Requester();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioByUsuario() async {
    Response resp =
        await req.get('/servicio-tramite/turnos/envios/paraentrega');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio = sedeModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(
      EnvioInterSedeModel interSedeModel, String codigo) async {
    Response resp =
        await req.get('/servicio-tramite/turnos/envios/paraentrega');
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<EnvioModel> validarCodigoProvider(String codigo, int id) async {
    try {
      Response resp = await req.get(
          '/servicio-tramite/turnos/$id/envios/paraagregaralrecorrido?paqueteId=$codigo');
      if (resp.data == "") {
        return null;
      }
      dynamic envio = resp.data;
      EnvioModel envioMode = envioModel.fromOneJson(envio);
      return envioMode;
    } catch (e) {
      return null;
    }
  }

    @override
  Future<int> listarEnviosValidadosInterSede(
      List<EnvioModel> enviosvalidados, int id) async {
    List<int> ids = new List();
    for (EnvioModel envio in enviosvalidados) {
      ids.add(envio.id);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post('/servicio-tramite/turnos/$id/recorridos', listaIds, null);
    int idresp = resp.data;
    return idresp;
  }
}
