import 'package:eventsource/eventsource.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/INotification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/Notification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/NotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';

class AppBarController {
  SseInterface sseInterface = new SseImpl(new SseProvider());

  INotificationCore notificationCore = new NotificationCore(new NotificacionProvider(), NotificacionPush.getInstance(new NotificacionProvider()));
  INotificationPush notificationPushCore = NotificacionPush.getInstance(new NotificacionProvider());
  
  List<NotificacionModel> listanotificaciones = [];

  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificacionespendientes = await notificationCore.listarNotificacionesPendientes();
    return notificacionespendientes;
  }

  Future<EventSource> ssEventSource() async {
    EventSource entregas = await sseInterface.listarEventSource();
    return entregas;
  }

  void cancelarNotificacionPushByBuzon(){
      notificationPushCore.cerrarNotificacionPush();
  }
}
