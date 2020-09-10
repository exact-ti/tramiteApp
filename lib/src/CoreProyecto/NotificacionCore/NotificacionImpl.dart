import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/INotificacionProvider.dart';
import 'NotificacionInterface.dart';

class NotificacionImpl implements NotificacionInterface {
  
  INotificacionProvider notificacionProvider;

  NotificacionImpl(INotificacionProvider notificacionProvider){
    this.notificacionProvider = notificacionProvider;
  }

  @override
  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
     List<NotificacionModel> palomarModel = await notificacionProvider.listarNotificacionesPendientes();
      return palomarModel;
  }

}
