import 'package:eventsource/eventsource.dart';
import 'package:tramiteapp/src/Providers/sseProvider/ISseProvider.dart';
import 'SseInterface.dart';

class SseImpl implements SseInterface {
  ISseProvider sseProvider;

  SseImpl(ISseProvider sseProvider) {
    this.sseProvider = sseProvider;
  }

  @override
  Future<EventSource> listarEventSource() async {
    EventSource responseSse = await sseProvider.eventSourceList();
    return responseSse;
  }
}
