import 'dart:async';
import 'dart:convert';
import 'package:tramiteapp/src/Resources/conection-sse/event.dart';

typedef RetryIndicator = void Function(Duration retry);

class EventSourceDecoder implements StreamTransformer<List<int>, Event> {
  RetryIndicator retryIndicator;

  EventSourceDecoder({this.retryIndicator});

  @override
  Stream<Event> bind(Stream<List<int>> stream) {
    Event currentEvent = new Event();
    bool _dataNueva = false;
    RegExp lineRegex = new RegExp(r"^([^:]*)(?::)?(?: )?(.*)?$");
    RegExp removeEndingNewlineRegex = new RegExp(r"^((?:.|\n)*)\n$");
    return stream
        .transform(new Utf8Decoder())
        .transform(new LineSplitter())
        .map<Event>((String line) {
      if (_dataNueva) {
        currentEvent = new Event();
        _dataNueva = false;
      }
      if (line.isEmpty) {
        // El evento ha terminado
        // Eliminar la nueva línea final de la data
        if (currentEvent.data != null) {
          var match = removeEndingNewlineRegex.firstMatch(currentEvent.data);
          currentEvent.data = match.group(1);
        }
        _dataNueva = true;
        return currentEvent;
      }
      // Hace match con el prefijo de la línea y el valor usando regex
      Match match = lineRegex.firstMatch(line);
      String field = match.group(1);
      String value = match.group(2) ?? "";
      if (field.isEmpty) {
        return null;
      }
      switch (field) {
        case "event":
          currentEvent.event = value;
          break;
        case "data":
          currentEvent.data = (currentEvent.data ?? "") + value + "\n";
          break;
        case "id":
          currentEvent.id = value;
          break;
        case "retry":
          if (retryIndicator != null) {
            retryIndicator(new Duration(milliseconds: int.parse(value)));
          }
          break;
      }
      return null;
    }).where((event) => event != null);
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<List<int>, Event, RS, RT>(this);
}
