import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import '../IConsultaProvider.dart';

class ConsultaProvider implements IConsultaProvider {
  
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  EnvioModel envioModel = new EnvioModel();
  UtdModel utdModel = new UtdModel();
  BuzonModel buzonModel = new BuzonModel();


  @override
  Future<List<EnvioModel>> listarByPaqueteAndDestinatarioAndRemitente(String paquete, String destinatario, String remitente,bool opcion) async {
    Response resp = await req.get(
        '/servicio-tramite/envios?paqueteId=$paquete&remitente=$remitente&destinatario=$destinatario&incluirInactivos=$opcion');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonConsultaEnvio(envio);
    return enviosMode;
  }

}