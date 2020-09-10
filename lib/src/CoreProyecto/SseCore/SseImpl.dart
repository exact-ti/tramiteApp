import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/sseProvider/ISseProvider.dart';
import 'SseInterface.dart';

class SseImpl implements SseInterface {
  ISseProvider sseProvider;

  SseImpl(ISseProvider sseProvider) {
    this.sseProvider = sseProvider;
  }

  @override
  Future<Stream<List<NotificacionModel>>> listarnotificaciones() async {
    Stream<List<NotificacionModel>> responseSse =
        await sseProvider.listNotificationsByUser();
    return responseSse;
  }

  @override
  Stream pruebaStreamCore(int number) async* {
    Stream<dynamic> responseSse = sseProvider.pruebaStreamProvider(number);
    responseSse.listen((value) {
       return value;
    });
  }

  @override
  Stream<List<NotificacionModel>> listarnotificaciones2() {
    Stream<List<NotificacionModel>> responseSse = sseProvider.listNotificationsByUser2();
    return responseSse;
  }
}
