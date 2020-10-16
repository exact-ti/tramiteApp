
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class NotificacionInterface {

    Future<List<NotificacionModel>> listarNotificacionesPendientes();
    
    Future<dynamic> revisarNotificacion(int notificacionId);
    
    Future<dynamic> verNotificaciones();
    }


