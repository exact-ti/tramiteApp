import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Util/local_notification.dart';

class NotificacionController {
  NotificacionInterface notificacionCore =
      new NotificacionImpl(new NotificacionProvider());
  var android = AndroidInitializationSettings('@mipmap/ic_launcher');
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();

  var iOS = IOSInitializationSettings();
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificacionespendientes =
        await notificacionCore.listarNotificacionesPendientes();
    return notificacionespendientes;
  }

  Future<dynamic> visitarNotificacion(int notificacionId) async {
    dynamic notificacionVisitada =
        await notificacionCore.revisarNotificacion(notificacionId);
    return notificacionVisitada;
  }

  Future<dynamic> verNotificaciones() async {
    dynamic notificacionVisitada = await notificacionCore.verNotificaciones();
    return notificacionVisitada;
  }

  void mostrarNotificacionPush(
      String mensaje, String ruta, BuildContext context) async {
    var initSetttings = InitializationSettings(android, iOS);
      FlutterLocalNotificationsPlugin flp = new FlutterLocalNotificationsPlugin();
    await flp.initialize(initSetttings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        dynamic respuestaBack = await verNotificaciones();
        if (respuestaBack["status"] == "success") {
          Navigator.pushNamed(context, ruta);
        }
      }
    });
    showNotification(mensaje, flp);
  }
}
