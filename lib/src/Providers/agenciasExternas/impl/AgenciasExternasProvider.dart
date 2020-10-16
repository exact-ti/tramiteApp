import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import '../IAgenciasExternasProvider.dart';

class AgenciaExternaProvider implements IAgenciaExternaProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();
  UtdModel utdModel = new UtdModel();

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioAgenciaByUsuario() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp =
        await req.get('/servicio-tramite/utds/$id/gruposagencias/activos');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio =
        sedeModel.fromJsonlistarEntregas(envios);
    return listEnvio;
  }


  @override
  Future<dynamic> listarEnviosAgenciaByCodigo(String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get(
        '/servicio-tramite/utds/$id/tipospaquetes/$valijaExternaId/paquetes/$codigo/envios');
    dynamic envios = resp.data;
    return envios;
  }

  @override
  Future<EnvioModel> validarCodigoAgenciaProvider(String bandeja,String codigo) async {
    try {
      Response resp = await req.get(
          '/servicio-tramite/tipospaquetes/valijas-agencia/$bandeja/paquetes/$codigo');
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
  Future<int> listarEnviosAgenciaValidadosInterSede(
      List<EnvioModel> enviosvalidados, String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    List<int> ids = new List();
    for (EnvioModel envio in enviosvalidados) {
      ids.add(envio.id);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post('/servicio-tramite/utds/$id/valijas/$codigo/tiposentregas/$valijaExternaId/entregas',
        listaIds,
        null);
    int idresp = resp.data;
    return idresp;
  }

  @override
  Future<bool> iniciarEntregaExternaIntersede(EnvioInterSedeModel envio) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    int agenciaid = envio.utdId;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/gruposagencias/$agenciaid/inicio',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> iniciarListaEntregaExternaIntersede(
      List<String> codigospaquetes) async {
    List<String> ids = new List();
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    for (String envio in codigospaquetes) {
      ids.add(envio);
    }
    final gruposIds = ids.reduce((value, element) => value + ',' + element);
    final Map<String, dynamic> parametros = {
      "gruposAgenciasIds": gruposIds,
    };
    Response resp = await req.post('/servicio-tramite/utds/$id/inicio', null, parametros);
    if (resp.data) {
      return true;
    }
    return false;
  }
}
                     