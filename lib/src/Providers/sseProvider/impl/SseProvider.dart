import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../ISseProvider.dart';

class SseProvider implements ISseProvider {
  Requester req = Requester();
  NotificacionModel notificacionModel = new NotificacionModel();


  @override
  Future<Stream<List<NotificacionModel>>> listNotificationsByUser() async {
    List<dynamic> listanot = new List();
    try {
      Stream response = await req.sse("/servicio-tramite/notificaciones/sse");
      return response.map((respuesta) {
        if (respuesta == null) {
          listanot = [];
        } else {
          listanot = [];
        }
        List<NotificacionModel> listNotificaciones =
            notificacionModel.fromJsonToNotificacion(listanot);
        return listNotificaciones;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<NotificacionModel>> listNotificationsByUser2() {
    try {
      Stream response = req.sse2("/servicio-tramite/notificaciones/sse");
      return response.where((event) {
        if (event["status"] == "success") {
          return true;
        } else {
          return false;
        }
      }).map((respuesta) {
        List<NotificacionModel> listNotificaciones =
            notificacionModel.fromJsonToNotificacion(respuesta["data"]);
        return listNotificaciones;
      });
    } catch (e) {
      return null;
    }
  }


}
