import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class INotificacionProvider {
  Future<List<NotificacionModel>> listarNotificacionesPendientes();
  Future<dynamic> modificarNotificacionesVistas();
  Future<dynamic> modificarNotificacionesRevisadas(int notificacionId);
  Future<dynamic> enviarNotificacionEnAusenciaRecojo(String paqueteId);
}
