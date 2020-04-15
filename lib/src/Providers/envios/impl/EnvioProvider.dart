import 'package:dio/dio.dart';
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
}
