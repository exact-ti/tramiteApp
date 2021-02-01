import 'dart:async';
import 'dart:convert';
import 'package:tramiteapp/src/CoreProyecto/Notification/INotification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/Notification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/Enumerator/SubscriptionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';
import 'package:tramiteapp/src/Resources/conection-sse/event.dart';
import 'package:tramiteapp/src/Resources/conection-sse/sse.dart';
import 'package:tramiteapp/src/services/locator.dart';
import '../../navigation_service_file.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/NotificationPush.core.dart';

class NotificacionBack {

  factory NotificacionBack.instance() => _instance;

  NotificacionBack._internal();

  final NavigationService _navigationService = locator<NavigationService>();

  NotificacionModel notificacionModel = new NotificacionModel();

  static final _instance = NotificacionBack._internal();

  INotificationCore notification = new NotificationCore(
      new NotificacionProvider(),
      NotificacionPush.getInstance(new NotificacionProvider()));
  INotificationPush notificationPush =
      NotificacionPush.getInstance(new NotificacionProvider());

  SseInterface sseCore = new SseImpl(new SseProvider());

  void startServerSentEvent(bool estadoAppOpen) async {
    EventSource eventSource = await sseCore.listarEventSource();
    StreamSubscription<Event> subscription;
    subscription = eventSource.listen((event) {
      dynamic respuesta = jsonDecode(event.data);
      String estadoApp = estadoAppOpen ? "FOREGROUND : " : "BACKGROUND : ";
      print(estadoApp + event.data);
      if (respuesta["status"] == "success") {
        List<NotificacionModel> listNotificaciones =
            notificacionModel.fromJsonToNotificacion(respuesta["data"]);
        if (estadoAppOpen) {
          notification.doNotification(listNotificaciones);
        } else {
          notificationPush.realizarnotificacionesPush(listNotificaciones);
        }
      }
      if (estadoAppOpen &&
          _navigationService.estadoFinalizar() ==
              SubscriptionEnum.SUBSCRIPTION_FINALIZAR) {
        subscription.cancel();
        eventSource.close();
      }
    });
  }
}
