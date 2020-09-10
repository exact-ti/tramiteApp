import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../ISseProvider.dart';

class SseProvider implements ISseProvider {
  Requester req = Requester();
  NotificacionModel notificacionModel = new NotificacionModel();

/* 
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    List<dynamic> listdata = new List();
    var initSetttings = InitializationSettings(android, iOS);
    flp.initialize(initSetttings); */

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

  @override
  Future modificarNotificacionesVistas() async {
/*     Response response =
        await req.put("/servicio-tramite/notificaciones/visto", null, null);
    return resp; */
  }

  @override
  Future modificarNotificacionesRevisadas(int notificacionId) async {
/*     Response resp = await req.put(
        "/servicio-tramite/notificaciones/$notificacionId/revision",
        null,
        null);
    return resp; */
  }

  @override
  Stream pruebaStreamProvider(int number) async* {
    print('waiting inside generator a bit :)');
    await new Future.delayed(new Duration(seconds: 5)); //sleep 5s
    print('started generating values...');
    for (int i = 0; i < number; i++) {
      await new Future.delayed(new Duration(seconds: 1)); //sleep 1s
      yield i;
    }
    print('ended generating values...');
  }
}
