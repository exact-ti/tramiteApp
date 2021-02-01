import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppOpenEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/INotificacionProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'INotification.core.dart';

class NotificationCore implements INotificationCore {

  final NavigationService _navigationService = locator<NavigationService>();

  INotificacionProvider notificacionProvider;

  INotificationPush notificationPush;

  NotificationCore(INotificacionProvider notificacionProvider, INotificationPush notificationPush) {
    this.notificacionProvider = notificacionProvider;
    this.notificationPush = notificationPush;
  }

  void doNotification(List<NotificacionModel> listNotificaciones) {
    if (_navigationService.retornarEstado() == EstadoAppOpenEnum.APP_PAUSED) {
      notificationPush.realizarnotificacionesPush(listNotificaciones);
    }
    _navigationService.setCantidadNotificacionBadge(listNotificaciones
        .where((notificacion) =>
            notificacion.notificacionEstadoModel.id ==
                EstadoNotificacionEnum.NOTIFICACION_PENDIENTE &&
            notificacion.buzonId == obtenerBuzonid())
        .toList()
        .length);
  }

    @override
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> listNotificaciones = await notificacionProvider.listarNotificaciones();
    return listNotificaciones
        .where((notificacion) => notificacion.buzonId == obtenerBuzonid())
        .toList();
  }

  @override
  Future revisarNotificacion(int notificacionId) async {
    return await notificacionProvider
        .modificarNotificacionesRevisadas(notificacionId);
  }

  @override
  Future verNotificaciones() async {
    return await notificacionProvider.modificarNotificacionesVistas();
  }

}
