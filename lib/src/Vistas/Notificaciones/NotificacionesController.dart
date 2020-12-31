import 'package:tramiteapp/src/CoreProyecto/Notification/INotification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/Notification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/NotificationPush.core.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'dart:async';

class NotificacionController {

  INotificationCore notificationCore = new NotificationCore(new NotificacionProvider(), NotificacionPush.getInstance(new NotificacionProvider()));
  INotificationPush notificationPushCore = NotificacionPush.getInstance(new NotificacionProvider());
  
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificacionespendientes =
        await notificationCore.listarNotificacionesPendientes();
    notificacionespendientes.sort((a, b) => b.fecha.compareTo(a.fecha));
    return notificacionespendientes;
  }

  Future<dynamic> visitarNotificacion(int notificacionId) async {
    dynamic notificacionVisitada =
        await notificationCore.revisarNotificacion(notificacionId);
    return notificacionVisitada;
  }

  Future<dynamic> verNotificaciones() async {
    dynamic notificacionVisitada = await notificationCore.verNotificaciones();
    return notificacionVisitada;
  }
}
