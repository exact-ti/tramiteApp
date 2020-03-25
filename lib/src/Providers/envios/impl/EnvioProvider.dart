import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'dart:convert';

class EnvioProvider implements IEnvioProvider {
  
  Requester req = Requester();

  ConfiguracionModel configuracionmodel = new ConfiguracionModel();


  @override
  void crearEnvioProvider(EnvioModel envio) async {
  

    final formData = json.encode( {
        "remitenteId" : envio.remitenteId,
        "destinatarioId": envio.destinatarioId,
        "codigoPaquete": envio.codigoPaquete,
        "codigoUbicacion": envio.codigoUbicacion,
        "observacion": envio.observacion
})          ;


    Response resp = await req.post('/servicio-tramite/envios',formData,null);
    final respuesta = resp.data;  
  }


}