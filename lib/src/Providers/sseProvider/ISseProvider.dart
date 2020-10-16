import 'package:eventsource/eventsource.dart';

abstract class ISseProvider {
  Future<EventSource> eventSourceList();
}
