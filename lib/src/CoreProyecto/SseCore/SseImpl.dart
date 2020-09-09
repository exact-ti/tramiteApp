import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/sseProvider/ISseProvider.dart';
import 'SseInterface.dart';

class SseImpl implements SseInterface {
  
  ISseProvider sseProvider;

  SseImpl(ISseProvider sseProvider) {
    this.sseProvider = sseProvider;
  }

  @override
  Future<Stream<List<NotificacionModel>>> listarnotificaciones() async{
     Stream<List<NotificacionModel>> responseSse = await sseProvider.listNotificationsByUser();
        return responseSse;
  }

}
