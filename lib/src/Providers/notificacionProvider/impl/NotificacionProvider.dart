import 'package:dio/dio.dart';
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

  @override
  Future<dynamic> modificarNotificacionesVistas() async {
    Response response =
        await req.put("/servicio-tramite/notificaciones/visto", null, null);
        dynamic responsedata = response.data;
    return responsedata;
  }

  @override
  Future<dynamic> modificarNotificacionesRevisadas(int notificacionId) async {
    Response response = await req.put(
        "/servicio-tramite/notificaciones/$notificacionId/revision",
        null,
        null);
        dynamic responsedata = response.data;
    return responsedata;
  }

}