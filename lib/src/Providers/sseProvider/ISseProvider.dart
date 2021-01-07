
import 'package:tramiteapp/src/Resources/conection-sse/sse.dart';

abstract class ISseProvider {
  Future<EventSource> eventSourceList();
}
