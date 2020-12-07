import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'dart:async';

class NotificacionController {

  NotificacionInterface notificacionCore = NotificacionImpl.getInstance(new NotificacionProvider());

  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificacionespendientes =
        await notificacionCore.listarNotificacionesPendientes();
    notificacionespendientes.sort((a, b) => b.fecha.compareTo(a.fecha));
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
}
