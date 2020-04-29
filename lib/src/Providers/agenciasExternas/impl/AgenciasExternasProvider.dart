import 'package:dio/dio.dart';
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
    /*Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/utdsparaentrega');
    List<dynamic> envios = resp.data;
    List<EnvioInterSedeModel> listEnvio = sedeModel.fromJsonEntregaExterna(envios);
    return listEnvio;*/

  List<EnvioInterSedeModel> listEnvio = await listarfake();
    return listEnvio;

  }


    Future<List<EnvioInterSedeModel>> listarfake() async{
    List<EnvioInterSedeModel> listarenvios = new List();
    EnvioInterSedeModel envio1 = new EnvioInterSedeModel();
    EnvioInterSedeModel envio2 = new EnvioInterSedeModel();
    envio1.destino="San Isidro";
    envio1.numdocumentos=20;
    envio1.numvalijas=30;
    envio1.codigo="123456";
    envio2.destino="La Molina";
    envio2.numdocumentos=20;
    envio2.numvalijas=4;
    envio2.codigo="123457";
    listarenvios.add(envio1);
    listarenvios.add(envio2);
    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }

  @override
  Future<List<EnvioModel>> listarEnviosAgenciaByCodigo(String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp =
        await req.get('/servicio-tramite/utds/$id/paquetes/$codigo/envios');
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<EnvioModel> validarCodigoAgenciaProvider(String codigo) async {
    try {
      Response resp = await req.get(
          '/servicio-tramite/turnos/envios/paraagregaralrecorrido?paqueteId=$codigo');
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
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/valijas/$codigo', listaIds, null);
    int idresp = resp.data;
    return idresp;
  }

  @override
  Future<bool> iniciarEntregaExternaIntersede(EnvioInterSedeModel envio) async {
   /* Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/utdsdestinos/$envio/iniciar',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;*/
    return false;
  }

  @override
  Future<bool> iniciarListaEntregaExternaIntersede(List<String> codigospaquetes) async {
  /* List<String> ids = new List();
    for (String envio in codigospaquetes) {
      ids.add(envio);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/paquetes/entrega',
        listaIds,
        null);
    if (resp.data) {
      return true;
    }
    return false;*/

    return true;
  }











    

}
