

import 'package:tramiteapp/src/Resources/conection-sse/sse.dart';

abstract class SseInterface {
    Future<EventSource> listarEventSource();
}
