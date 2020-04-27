import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import '../IInterSedeProvider.dart';

class InterSedeProvider implements IInterSedeProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();
  UtdModel utdModel = new UtdModel();

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioByUsuario() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/utdsparaentrega');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio = sedeModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<EnvioInterSedeModel>> listarRecepcionByUsuario() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/tiposentregas/$entregaValijaId/entregas/recepcion');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio =
        sedeModel.fromJsonValidarRecepcion(envios);
    return listEnvio;
  }

  @override
  Future<List<EnvioInterSedeModel>> listarRecepcionByUsuario2() async {
    List<EnvioInterSedeModel> listEnvio = await listarfake();
    return listEnvio;
  }

  Future<List<EnvioInterSedeModel>> listarfake() async {
    List<EnvioInterSedeModel> envios = new List();
    EnvioInterSedeModel envio = new EnvioInterSedeModel();
    EnvioInterSedeModel envio2 = new EnvioInterSedeModel();
    envio.utdId = 1;
    envio.numdocumentos = 2;
    envio.codigo = "UTD0005";
    envio.destino = "Brasil";
    envio2.utdId = 2;
    envio2.numdocumentos = 3;
    envio2.codigo = "abcd";
    envio2.destino = "Perú";
    envios.add(envio);
    envios.add(envio2);

    return Future.delayed(new Duration(seconds: 1), () {
      return envios;
    });
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp =
        await req.get('/servicio-tramite/utds/$id/paquetes/$codigo/envios');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<EnvioModel> validarCodigoProvider(
      String codigo, String codigobandeja) async {
    try {
      Response resp = await req.get(
          '/servicio-tramite/tipospaquetes/valijas/$codigobandeja/paquetes/$codigo');
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
      List<EnvioModel> enviosvalidados, String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    List<int> ids = new List();
    for (EnvioModel envio in enviosvalidados) {
      ids.add(envio.id);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/valijas/$codigo', listaIds, null);
    int idresp = resp.data;
    return idresp;
  }

  @override
  Future<bool> iniciarEntregaIntersede(int utdDestino) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/utdsdestinos/$utdDestino/iniciar',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<EnvioModel>> listarRecepcionByCodigo(String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp =
        await req.get('/servicio-tramite/utds/$id/entregas/$codigo/recepcion');
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<bool> registrarRecojoIntersedeProvider(
      String codigo, String codigopaquete) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/paquetes/$codigopaquete/custodia',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }
}
