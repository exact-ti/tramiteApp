import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Resources/conection-sse/sse.dart';
import '../ISseProvider.dart';

class SseProvider implements ISseProvider {
  Requester req = Requester();




  @override
  Future<EventSource> eventSourceList() async {
      EventSource response = await req.sseventSource("/servicio-tramite/notificaciones/sse");
      return response;
  }

}
