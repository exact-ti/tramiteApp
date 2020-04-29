import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

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
  Future<TrackingModel> mostrarTracking(String codigo) async {
    Response resp = await req.get('/servicio-tramite/recorridos/$codigo/areas');
    dynamic respuesta = resp.data;
    TrackingModel trackingRespuesta = trackingModel.fromOneJsonTracking(respuesta);
    return trackingRespuesta;
  }

    @override
  Future<TrackingModel> mostrarTracking2(String codigo) async {
    TrackingModel listEnvio = await listarfake(codigo);
    return listEnvio;
  }

  Future<TrackingModel> listarfake(String codigo) async{
    if(codigo=="123456"){
    TrackingModel envio1 = new TrackingModel();
    TrackingDetalleModel detalle1 = new TrackingDetalleModel();
    TrackingDetalleModel detalle2 = new TrackingDetalleModel();
    List<TrackingDetalleModel> detalles = new List();
    envio1.codigo="123456";
    envio1.remitente="Ronald Santos";
    envio1.origen="diamantes";
    envio1.destinatario="Orlando Heredia";
    envio1.destino="Aqui pe";
    envio1.area="Contabilidad";
    envio1.observacion="Es una observación simple";
    detalle1.fecha="Martes jueves";
    detalle1.remitente="Oscar leon";
    detalle1.sede="La victoria";
    detalle1.area="Administración";
    detalle2.fecha="Miercoles";
    detalle2.remitente="jorge benavides";
    detalle2.sede="San miguel";
    detalle2.area="TI";
    detalles.add(detalle1);
    detalles.add(detalle2);
    envio1.detalles=detalles;
    return Future.delayed(new Duration(seconds: 1), () {
      return envio1;
    });
    }

    if(codigo=="123457"){
    TrackingModel envio2 = new TrackingModel();
    TrackingDetalleModel detalle3 = new TrackingDetalleModel();
    TrackingDetalleModel detalle4 = new TrackingDetalleModel();
    List<TrackingDetalleModel> detalles2 = new List();
    envio2.codigo="123457";
    envio2.remitente="Ariana Bolo Arce";
    envio2.origen="minas";
    envio2.destinatario="Kathe macedo";
    envio2.destino="TI";
    envio2.area="Recursos humanos";
    envio2.observacion="Es un envio complicado";
    detalle3.fecha="12/415/45";
    detalle3.remitente="Mirella";
    detalle3.sede="La granja villa";
    detalle3.area="Operación";
    detalle4.fecha="Jueves";
    detalle4.remitente="Carlos fernando";
    detalle4.sede="Cercado de lima";
    detalle4.area="Comercial";
    detalles2.add(detalle3);
    detalles2.add(detalle4);
    envio2.detalles=detalles2;
    return Future.delayed(new Duration(seconds: 1), () {
      return envio2;
    });
    }

    if(codigo=="123458"){
    TrackingModel envio1 = new TrackingModel();
    TrackingDetalleModel detalle1 = new TrackingDetalleModel();
    TrackingDetalleModel detalle2 = new TrackingDetalleModel();
    List<TrackingDetalleModel> detalles = new List();
    envio1.codigo="123458";
    envio1.remitente="Lorena Taipe";
    envio1.origen="diamantes";
    envio1.destinatario="Orlando Heredia";
    envio1.destino="Aqui pe";
    envio1.area="Contabilidad";
    envio1.observacion="Es una observación simple";
    detalle1.fecha="Martes jueves";
    detalle1.remitente="Oscar leon";
    detalle1.sede="La victoria";
    detalle1.area="Administración";
    detalle2.fecha="Miercoles";
    detalle2.remitente="jorge benavides";
    detalle2.sede="San miguel";
    detalle2.area="TI";
    detalles.add(detalle1);
    detalles.add(detalle2);
    envio1.detalles=detalles;
    return Future.delayed(new Duration(seconds: 1), () {
      return envio1;
    });
    }


        if(codigo=="123459"){
    TrackingModel envio1 = new TrackingModel();
    TrackingDetalleModel detalle1 = new TrackingDetalleModel();
    TrackingDetalleModel detalle2 = new TrackingDetalleModel();
    List<TrackingDetalleModel> detalles = new List();
    envio1.codigo="123458";
    envio1.remitente="Romina guardia";
    envio1.origen="diamantes";
    envio1.destinatario="Orlando Heredia";
    envio1.destino="Aqui pe";
    envio1.area="Contabilidad";
    envio1.observacion="Es una observación simple";
    detalle1.fecha="Martes jueves";
    detalle1.remitente="Oscar leon";
    detalle1.sede="La victoria";
    detalle1.area="Administración";
    detalle2.fecha="Miercoles";
    detalle2.remitente="jorge benavides";
    detalle2.sede="San miguel";
    detalle2.area="TI";
    detalles.add(detalle1);
    detalles.add(detalle2);
    envio1.detalles=detalles;
    return Future.delayed(new Duration(seconds: 1), () {
      return envio1;
    });
    }
  return null;
  }


}
