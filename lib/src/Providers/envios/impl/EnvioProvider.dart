import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
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

  @override
  void crearEnvioProvider(EnvioModel envio) async {
    final formData = json.encode({
      "remitenteId": envio.remitenteId,
      "destinatarioId": envio.destinatarioId,
      "codigoPaquete": envio.codigoPaquete,
      "codigoUbicacion": envio.codigoUbicacion,
      "observacion": envio.observacion
    });

    Response resp = await req.post('/servicio-tramite/envios', formData, null);
    final respuesta = resp.data;
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
  Future<List<EnvioModel>> listarEnviosActivosByUsuario() async {
    Map<String,dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp = await req.get(
        '/servicio/tramite/buzones/$id/envios/confirmacion');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidarRecepcion(envio);
    return enviosMode;
  }



    @override
  Future<List<EnvioModel>> listarRecepcionesActivas()async {
    Map<String,dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp = await req.get(
        '/servicio/tramite/buzones/$id/envios/confirmacion');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidarRecepcion(envio);
    return enviosMode;
  }


  @override
  Future<List<EnvioModel>> listarEnviosActivosByUsuario2() async {
    List<EnvioModel> enviosMode =  await listarfake1();
    return enviosMode;
  }



    @override
  Future<List<EnvioModel>> listarRecepcionesActivas2()async {
    List<EnvioModel> enviosMode = await listarfake2();
    return enviosMode;
  }


    Future<List<EnvioModel>> listarfake1() async{
    List<EnvioModel> listarenvios = new List();
    EnvioModel envio1 = new EnvioModel();
    EnvioModel envio2 = new EnvioModel();
    envio1.observacion="San Ica";
    envio1.usuario="Ronald Vega";
    envio1.codigoPaquete="123456";
    envio2.observacion="La PEru";
    envio2.usuario="Crhistian Maman";
    envio2.codigoPaquete="123457";
    listarenvios.add(envio1);
    listarenvios.add(envio2);
    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }

    Future<List<EnvioModel>> listarfake2() async{
    List<EnvioModel> listarenvios = new List();
    EnvioModel envio1 = new EnvioModel();
    EnvioModel envio2 = new EnvioModel();
    envio1.observacion="San Isidro";
    envio1.usuario="Ronald Santos";
    envio1.codigoPaquete="123458";
    envio2.observacion="La Molina";
    envio2.usuario="Crhistian campos";
    envio2.codigoPaquete="123459";
    listarenvios.add(envio1);
    listarenvios.add(envio2);
    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }
}
