
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class INotificationCore {
  
  Future<List<NotificacionModel>> listarNotificacionesPendientes();

  Future<dynamic> revisarNotificacion(int notificacionId);

  Future<dynamic> verNotificaciones();

  void doNotification(List<NotificacionModel> listNotificaciones);
}
