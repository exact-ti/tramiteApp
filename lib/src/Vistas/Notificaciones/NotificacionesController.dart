import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'dart:async';
import 'package:tramiteapp/src/Enumerator/CancelSubcripcion.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';


class NotificacionController {
  NotificacionInterface notificacionCore =
      new NotificacionImpl(new NotificacionProvider());
  var android = AndroidInitializationSettings('@mipmap/ic_launcher');
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
  final NavigationService _navigationService = locator<NavigationService>();
 SseInterface sseInterface = new SseImpl(new SseProvider());
  NotificacionModel notificacionModel = new NotificacionModel();
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

  void mostrarNotificacionPush(String mensaje, String ruta) async {
    var initSetttings = InitializationSettings(android, iOS);
    FlutterLocalNotificationsPlugin flp = new FlutterLocalNotificationsPlugin();
    await flp.initialize(initSetttings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        dynamic respuestaBack = await verNotificaciones();
        if (respuestaBack["status"] == "success") {
          _navigationService.navigationToHome(ruta);
        }
      }
    });
    showNotification(mensaje, flp);
  }

  realizarnotificacionPush(List<NotificacionModel> listarNotificaciones) {
    List<NotificacionModel> listarNotificacionesPendientes = listarNotificaciones
                .where((element) =>
                    element.notificacionEstadoModel.id == pendiente)
                .toList();
    listarNotificacionesPendientes.length > 1
        ? mostrarNotificacionPush(
            "tiene ${listarNotificacionesPendientes.length} notificaciones nuevas",
            "/notificaciones",
          )
        : mostrarNotificacionPush(
            listarNotificacionesPendientes.first.mensaje, listarNotificacionesPendientes.first.ruta);
  }


    void gestionNotificacioneFutures() async {
    EventSource notificacionesStream = await sseInterface.listarEventSource();
    StreamSubscription<Event> subscription;
    subscription = notificacionesStream.listen((event) {
      dynamic respuesta = jsonDecode(event.data);
      print(event.data);
      if (respuesta["status"] == "success") {
        List<NotificacionModel> listarNotificaciones = notificacionModel.fromJsonToNotificacion(respuesta["data"]);
        if (_navigationService.retornarEstado() == paused) {
          realizarnotificacionPush(listarNotificaciones);
        }
        _navigationService.realizarnotificacion(listarNotificaciones.where((element) =>
                    element.notificacionEstadoModel.id == pendiente)
                .toList().length);
      }
      if (_navigationService.estadoFinalizar() == finalizar) {
        subscription.cancel();
      }
    });
  }
}
