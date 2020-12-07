import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../INotificacionProvider.dart';


class NotificacionProvider implements INotificacionProvider {
  
  Requester req = Requester();
  NotificacionModel notificacionModel = new NotificacionModel();

  @override
  Future<List<NotificacionModel>> listarNotificaciones() async {
    Response resp = await req.get('/servicio-tramite/notificaciones/pendientes');
    dynamic respuestaData = resp.data;
    return notificacionModel.fromJsonToNotificacion(respuestaData["data"]);
  }

  @override
  Future modificarNotificacionesVistas() async {
    Response response = await req.put("/servicio-tramite/notificaciones/visto", null, null);
    return response.data;
  }

  @override
  Future modificarNotificacionesRevisadas(int notificacionId) async {
    Response response = await req.put("/servicio-tramite/notificaciones/$notificacionId/revision",null,null);
    return response.data;
  }

  @override
  Future enviarNotificacionEnAusenciaRecojo(String paqueteId) async {
    Response resp = await req.post(
        '/servicio-tramite/envios/notificaciones/creadopendiente', null, {
      "paqueteId": paqueteId,
    });
    return resp.data;
  }

}