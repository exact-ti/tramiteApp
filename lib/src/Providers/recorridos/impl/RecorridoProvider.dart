import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import '../IRecorridoProvider.dart';

class RecorridoProvider implements IRecorridoProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  EnvioModel envioModel = new EnvioModel();
  RecorridoModel recorridoModel = new RecorridoModel();
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();
  TipoEntregaPersonalizadaModel tipopersonalizada =
      new TipoEntregaPersonalizadaModel();
  @override
  Future<dynamic> enviosEntregaProvider(String codigo, int id) async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/$id/areas/$codigo/envios/paraentrega');
    if (resp.data == "") {
      return null;
    }
    dynamic envio = resp.data;
   /* List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);*/
    return envio;
  }

  @override
  Future<List<EnvioModel>> enviosRecojoProvider(
      String codigo, int recorridoId) async {
    try {
      Response resp = await req.get('/servicio-tramite/areas/$codigo/envios');
      if (resp.data == "") {
        return null;
      }
      List<dynamic> envio = resp.data;
      List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
      return enviosMode;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<dynamic> registrarEntregaProvider(
      String codigo, int recorridoId, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/areas/$codigo/paquetes/$codigopaquete/entrega',
        null,
        null);
    return resp.data;
  } 

  @override
  Future<dynamic> registrarRecojoProvider(
      String codigo, int recorridoId, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/areas/$codigo/paquetes/$codigopaquete/recojo',
        null,
        null);
    dynamic respuesta = resp.data;
    return respuesta;
  }

  @override
  Future<bool> registrarEntregaPersonalizadaProvider(
      String dni, String codigopaquete) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/paquetes/$codigopaquete/entregapersonalizada/tiposcargos/1?codigo_usuario=$dni',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada() async {
    bool interno = false;
    Response resp = await req
        .get('/servicio-tramite/tiposcargos?incluirInactivos=$interno');
    List<dynamic> tipoPaquetes = resp.data;
    List<TipoEntregaPersonalizadaModel> listTipoPaquete =
        tipopersonalizada.fromJson(tipoPaquetes);
    return listTipoPaquete;
  }

  @override
  Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(
      String firma, String codigopaquete) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;

    /* FormData formData =
        FormData.fromMap({"file": MultipartFile.fromString(firma)}); */
    dynamic formato = new MediaType('image', 'png');
    FormData formData =FormData.fromMap({"file": MultipartFile.fromBytes(Base64Decoder().convert(firma), contentType: formato,filename:"file.png")}); 

    Response resp = await req.post(
        '/servicio-tramite/utds/$id/paquetes/$codigopaquete/entregapersonalizada/tiposcargos/2',
        formData,
        null);
    return resp.data;
  }
}
