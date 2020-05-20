import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import '../IRecepcionProvider.dart';

class RecepcionProvider implements IRecepcionProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  EnvioModel envioModel = new EnvioModel();
  RecorridoModel recorridoModel = new RecorridoModel();
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();
  BuzonModel buzonModel = new BuzonModel();
  @override
  Future<List<EnvioModel>> recepcionJumboProvider(String codigo) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get(
        '/servicio-tramite/utds/$id/lotes/$codigo/recepcion');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> recepcionValijaProvider(
      String codigo) async {
    Response resp = await req.get('/servicio-tramite/areas/$codigo/envios');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<bool> registrarJumboProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> recibirJumboProvider(
     String codigoLote,String codigopaquete) async {
           Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/entregas/$codigopaquete/recepcion');
    List<dynamic> envio = resp.data;
    if (envio.length!=0) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> registrarValijaProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/recojo',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<EnvioModel>> listarenvios() async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/areas//envios/paraentrega');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<bool> registrarEnvioProvider(String codigopaquete) async{
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<EnvioModel>> listarenviosPrincipal() async{
    Map<String,dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp = await req.get(
        '/servicio-tramite/buzones/$id/envios/confirmacion');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidarRecepcion(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> listarenviosPrincipal2() async {
    List<EnvioModel> listEnvio = await listarfake();
    return listEnvio;
  }

  Future<List<EnvioModel>> listarfake() async{
    List<EnvioModel> listarenvios = new List();
    EnvioModel envio1 = new EnvioModel();
    EnvioModel envio2 = new EnvioModel();
    envio1.observacion="San Isidro";
    envio1.usuario="Ronald Santos";
    envio1.codigoPaquete="123456";
    envio2.observacion="La Molina";
    envio2.usuario="Crhistian campos";
    envio2.codigoPaquete="123457";
    listarenvios.add(envio1);
    listarenvios.add(envio2);

    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }

  @override
  Future<bool> registrarEnvioPrincipalProvider(String codigopaquete) async {
   /* Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;*/
    return false;
  }

  @override
  Future<bool> registrarListaEnvioPrincipalProvider(List<String> codigospaquetes) async {
        Map<String,dynamic> buzon = json.decode(_prefs.buzon);
        print("Entro a provider");
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
       List<String> ids = new List();
    for (String envio in codigospaquetes) {
      ids.add(envio);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post('/servicio-tramite/buzones/$id/envios/confirmacion',listaIds,null);
    if (resp.data) {
      return true;
    }
    return false;
  
  }



}
