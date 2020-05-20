import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import '../ITrackingProvider.dart';


class TrackingProvider implements ITrackingProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  TrackingModel trackingModel = new TrackingModel();
  RecorridoModel recorridoModel = new RecorridoModel(); 
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();
  

  @override
  Future<TrackingModel> mostrarTracking(int codigo) async {
    Response resp = await req.get('/servicio-tramite/envios/$codigo/detalle');
    Response resp2 = await req.get('/servicio-tramite/envios/$codigo/seguimientos');
    dynamic respuesta = resp.data;
    List<dynamic> respuesta2 = resp2.data;
    TrackingModel trackingRespuesta = trackingModel.fromOneJsonTracking(respuesta,respuesta2);
    return trackingRespuesta;
  }

    @override
  Future<TrackingModel> mostrarTracking2(String codigo) async {
    TrackingModel listEnvio/* = await listarfake(codigo)*/;
    return listEnvio;
  }




}
