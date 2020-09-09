import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';


class TopBarController {
  SseInterface sseInterface = new SseImpl(new SseProvider());
      
  Future<Stream<List<NotificacionModel>>> esucharnotificaciones() async {
    Stream<List<NotificacionModel>> entregas = await sseInterface.listarnotificaciones();
    return entregas;
  }
}