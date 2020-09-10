import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class ISseProvider {
  Future<Stream<List<NotificacionModel>>> listNotificationsByUser();
  Stream<List<NotificacionModel>> listNotificationsByUser2();
  Future<dynamic> modificarNotificacionesVistas();
  Future<dynamic> modificarNotificacionesRevisadas(int notificacionId);
  Stream<dynamic> pruebaStreamProvider(int number);
}
