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

  @override
  Future<List<EnvioModel>> listarByPaqueteAndDestinatarioAndRemitente2(String paquete, String destinatario, String remitente,bool opcion)async {
    print(paquete);
       print(destinatario);
    print(remitente);
 
    List<EnvioModel> enviosMode = await listarfake1(opcion);
    return enviosMode;
  }


    Future<List<EnvioModel>> listarfake1(bool opcion) async{
    List<EnvioModel> listarenvios = new List();
    EnvioModel envio1 = new EnvioModel();
    EnvioModel envio2 = new EnvioModel();
    if(opcion){
            envio1.codigoPaquete = "paquete";
            envio1.destinatario = "destinatario";
            envio1.remitente = "remitente";
            envio1.codigoUbicacion = "ubicacion";
    listarenvios.add(envio1);

    }else{
            envio2.codigoPaquete = "paquete2";
            envio2.destinatario = "destinatario2";
            envio2.remitente = "remitente2";
            envio2.codigoUbicacion = "ubicacion2";
    listarenvios.add(envio2);

    }
    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }

}