
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

class SseInterface {
    Future<Stream<List<NotificacionModel>>> listarnotificaciones() async {}
    Stream<List<NotificacionModel>> listarnotificaciones2()  {}
    Stream<dynamic> pruebaStreamCore(int number){}

}
