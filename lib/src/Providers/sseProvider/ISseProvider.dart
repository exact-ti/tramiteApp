abstract class ISseProvider{
  Future<Stream<dynamic>> listNotificationsByUser();
  Future<dynamic> modificarNotificacionesVistas();
  Future<dynamic> modificarNotificacionesRevisadas(int notificacionId);


}