import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/Service-Background/BackgroundService.dart';
import 'package:tramiteapp/src/services/Service-Background/service-notificaciones/NotificacionesBack.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'dart:async';
import 'package:tramiteapp/src/Providers/notificacionProvider/INotificacionProvider.dart';
import 'INotificationPush.core.dart';

class NotificacionPush implements INotificationPush {
  INotificacionProvider notificacionProvider;
  SseInterface sseCore = new SseImpl(new SseProvider());
  BuzonInterface buzonCore = new BuzonImpl(new BuzonProvider());
  final NavigationService _navigationService = locator<NavigationService>();
  NotificacionModel notificacionModel = new NotificacionModel();
  FlutterLocalNotificationsPlugin flp;
  static NotificacionPush notificacionImpl;
  final _prefs = new PreferenciasUsuario();

  NotificacionPush._internal(INotificacionProvider notificacionProvider) {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    flp = new FlutterLocalNotificationsPlugin();
    flp.initialize(InitializationSettings(android, iOS),
        onSelectNotification: onSelectNotification);
    this.notificacionProvider = notificacionProvider;
  }

  static getInstance(INotificacionProvider notificacionProvider) {
    if (notificacionImpl == null) {
      notificacionImpl = NotificacionPush._internal(notificacionProvider);
    }
    return notificacionImpl;
  }

  @override
  void realizarnotificacionesPush(
      List<NotificacionModel> listarNotificaciones) async {
    Map<dynamic, List<NotificacionModel>> notificacionesByBuzones = new Map();
    List<NotificacionModel> listarNotificacionesPendientes =
        listarNotificaciones
            .where((element) =>
                element.notificacionEstadoModel.id ==
                EstadoNotificacionEnum.NOTIFICACION_PENDIENTE)
            .toList();
    listarNotificacionesPendientes.forEach((notificacionPendiente) {
      if (notificacionesByBuzones.containsKey(notificacionPendiente.buzonId)) {
        notificacionesByBuzones.update(notificacionPendiente.buzonId,
            (listNotificaciones) {
          listNotificaciones.add(notificacionPendiente);
          return listNotificaciones;
        });
      } else {
        List<NotificacionModel> listarNot = new List();
        listarNot.add(notificacionPendiente);
        notificacionesByBuzones[notificacionPendiente.buzonId] = listarNot;
      }
    });

    notificacionesByBuzones.forEach((buzonId, lisNotificaciones) {
      if (lisNotificaciones.length > 1) {
        configurarNotificacion(
            buzonId,
            "Buzón " + buzonCore.obtenerNombreBuzonById(buzonId),
            "Tienes ${lisNotificaciones.length} notificaciones",
            "/notificaciones",
            null);
      } else {
        configurarNotificacion(
            buzonId,
            "Buzón " + buzonCore.obtenerNombreBuzonById(buzonId),
            lisNotificaciones.first.mensaje,
            lisNotificaciones.first.ruta,
            lisNotificaciones.first.id);
      }
    });
  }

  void configurarNotificacion(int buzonId, String titulo, String mensaje,
      String ruta, int notificacionIndividualId) async {
    Map<String, dynamic> mapData = new Map();
    mapData["buzonId"] = buzonId;
    mapData["notificacionId"] = notificacionIndividualId;
    mapData["ruta"] = ruta;
    showNotification(buzonId, titulo, mensaje, ruta, json.encode(mapData), flp);
  }

  void showNotification(int notificacionId, String titulo, String mensaje,
      String ruta, String palyload, flp) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'ticker',
        autoCancel: true,
        ongoing: true);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flp.show(notificacionId, titulo, mensaje, platform,
        payload: palyload);
  }

  Future onSelectNotification(String payload) async {
    dynamic mapDataNotificacion = json.decode(payload);
    if (payload != null) {
      buzonCore.changeBuzonById(mapDataNotificacion["buzonId"]);
        _prefs.openByNotificationPush = true;
      if (isCliente()) {
        _navigationService.setCantidadNotificacionBadge(0);
        if (mapDataNotificacion["notificacionId"] != null) {
          await notificacionProvider.modificarNotificacionesRevisadas(
              mapDataNotificacion["notificacionId"]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigationService.navigationClienteToOneNotification(mapDataNotificacion["ruta"]);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigationService
                .navigationClienteToNotifications(mapDataNotificacion["ruta"])
                .whenComplete(() async {
              List<NotificacionModel> listNotificaciones =
                  await notificacionProvider.listarNotificaciones();
              _navigationService.setCantidadNotificacionBadge(listNotificaciones
                  .where((notificacion) =>
                      notificacion.buzonId == obtenerBuzonid())
                  .toList()
                  .where((notificacion) =>
                      notificacion.notificacionEstadoModel.id ==
                      EstadoNotificacionEnum.NOTIFICACION_PENDIENTE)
                  .toList()
                  .length);
            });
          });
        }
        BackgroundService.startBackground();
      } else {
        _navigationService.setCantidadNotificacionBadge(0);
        if (mapDataNotificacion["notificacionId"] != null) {
          await notificacionProvider.modificarNotificacionesRevisadas(
              mapDataNotificacion["notificacionId"]);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigationService.navigationExactToNotifications(mapDataNotificacion["ruta"]);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigationService
                .navigationExactToNotifications(mapDataNotificacion["ruta"])
                .whenComplete(() async {
              List<NotificacionModel> listNotificaciones =
                  await notificacionProvider.listarNotificaciones();
              _navigationService.setCantidadNotificacionBadge(listNotificaciones
                  .where((notificacion) =>
                      notificacion.buzonId == obtenerBuzonid())
                  .toList()
                  .where((notificacion) =>
                      notificacion.notificacionEstadoModel.id ==
                      EstadoNotificacionEnum.NOTIFICACION_PENDIENTE)
                  .toList()
                  .length);
            });
          });
        }
        BackgroundService.startBackground();
      }
    }
  }

  @override
  Future enviarNotificacionEnAusenciaRecojo(String paqueteId) {
    return notificacionProvider.enviarNotificacionEnAusenciaRecojo(paqueteId);
  }

  @override
  void cerrarNotificacionPush() async {
    int numNotificaciones = _navigationService.getCantidadNotificaciones();
    if (numNotificaciones > 0) {
      List<NotificacionModel> listNotificaciones =
          await notificacionProvider.listarNotificaciones();
      if (listNotificaciones
          .where((notificacion) =>
              notificacion.notificacionEstadoModel.id ==
                  EstadoNotificacionEnum.NOTIFICACION_PENDIENTE &&
              notificacion.buzonId == obtenerBuzonid())
          .toList()
          .isNotEmpty) {
        this.flp.cancel(obtenerBuzonid());
      }
    }
  }

  @override
  Future notificarMasivoRecojo(int recorridoId) async {
    return await notificacionProvider.notificarMasivoRecojo(recorridoId);
  }
  
}
