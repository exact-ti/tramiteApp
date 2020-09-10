import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

import '../INotificacionProvider.dart';


class NotificacionProvider implements INotificacionProvider {
  
  Requester req = Requester();

  NotificacionModel notificacionclase = new NotificacionModel();

  @override
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    Response resp = await req.get('/servicio-tramite/notificaciones/pendientes');
     dynamic respuestaData = resp.data;
    List<dynamic> respdatalist = respuestaData["data"];
    List<NotificacionModel> listNotificaciones = notificacionclase.fromJsonToNotificacion(respdatalist);
    return listNotificaciones;
  }

}