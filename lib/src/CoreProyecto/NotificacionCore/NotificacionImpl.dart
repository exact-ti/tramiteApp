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
    return await notificacionProvider.listarNotificacionesPendientes();
  }

  @override
  Future revisarNotificacion(int notificacionId) async {
    return await notificacionProvider.modificarNotificacionesRevisadas(notificacionId);
  }

  @override
  Future verNotificaciones() async{
    return await notificacionProvider.modificarNotificacionesVistas();
  }
}
