import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class INotificacionProvider {
  Future<List<NotificacionModel>> listarNotificaciones();
  Future<dynamic> modificarNotificacionesVistas();
  Future<dynamic> modificarNotificacionesRevisadas(int notificacionId);
  Future<dynamic> enviarNotificacionEnAusenciaRecojo(String paqueteId);
  Future<dynamic> notificarMasivoRecojo(int recorridoId);
}
