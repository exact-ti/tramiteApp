
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class INotificationPush {

  Future<dynamic> enviarNotificacionEnAusenciaRecojo(String paqueteId);

  void cerrarNotificacionPush();

  Future<dynamic> notificarMasivoRecojo(int recorridoId);

  void realizarnotificacionesPush( List<NotificacionModel> listarNotificaciones);

}
