
import 'package:eventsource/eventsource.dart';

abstract class SseInterface {
    Future<EventSource> listarEventSource();
}
