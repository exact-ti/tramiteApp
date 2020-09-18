import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/INotificacionProvider.dart';
import 'NotificacionInterface.dart';

class NotificacionImpl implements NotificacionInterface {
  INotificacionProvider notificacionProvider;

  NotificacionImpl(INotificacionProvider notificacionProvider) {
    this.notificacionProvider = notificacionProvider;
  }

  @override
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificaciones =
        await notificacionProvider.listarNotificacionesPendientes();
    return notificaciones;
  }

  @override
  Future revisarNotificacion(int notificacionId) async {
    dynamic notificacionApi =
        await notificacionProvider.modificarNotificacionesRevisadas(notificacionId);
    return notificacionApi;
  }

  @override
  Future verNotificaciones() async{
    dynamic notificacionApi =
        await notificacionProvider.modificarNotificacionesVistas();
        
    return notificacionApi;
  }
}
