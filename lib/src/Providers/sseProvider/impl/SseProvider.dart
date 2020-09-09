import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../ISseProvider.dart';
import 'package:http/http.dart';

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
     try{
        Stream<dynamic> response = await req.sse("/servicio-tramite/notificaciones/sse");
        return response.map((respuesta){
          if(respuesta["data"]==null){
          listanot = [];
          }else{
          listanot = respuesta["data"];
          }
          List<NotificacionModel> listNotificaciones= notificacionModel.fromJsonToNotificacion(listanot);
          return listNotificaciones;
        });
     }catch(e){
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
}
