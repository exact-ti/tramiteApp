import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import "package:http/src/utils.dart" show encodingForCharset;
import "package:http_parser/http_parser.dart" show MediaType;
import 'package:tramiteapp/src/Resources/conection-sse/event.dart';
import 'package:tramiteapp/src/Resources/conection-sse/event.source.decoder.dart';

enum EventSourceReadyState {
  CONNECTING,
  OPEN,
  CLOSED,
}

class EventSourceSubscriptionException extends Event implements Exception {
  int statusCode;
  String message;

  @override
  String get data => "$statusCode: $message";

  EventSourceSubscriptionException(this.statusCode, this.message)
      : super(event: "error");
}

class EventSource extends Stream<Event> {
  final Uri url;
  final Map headers;

  EventSourceReadyState get readyState => _readyState;

  Stream<Event> get onOpen => this.where((e) => e.event == "open");
  Stream<Event> get onMessage => this.where((e) => e.event == "message");
  Stream<Event> get onError => this.where((e) => e.event == "error");

  StreamController<Event> _streamController =
      new StreamController<Event>.broadcast();

  EventSourceReadyState _readyState = EventSourceReadyState.CLOSED;

  http.Client client;
  Duration _retryDelay = const Duration(milliseconds: 3000);

  String _lastEventId;
  EventSourceDecoder _decoder;
  String _body;
  String _method;

  EventSource._internal(this.url, this.client, this._lastEventId, this.headers,
      this._body, this._method) {
    _decoder = new EventSourceDecoder(retryIndicator: _updateRetryDelay);
  }

  static Future<EventSource> conectar(url,
      {http.Client client,
      String lastEventId,
      Map headers,
      String body,
      String method}) async {
    // parameter initialization
    url = url is Uri ? url : Uri.parse(url);
    client = client ?? new http.Client();
    lastEventId = lastEventId ?? "";
    body = body ?? "";
    method = method ?? "GET";
    EventSource es = new EventSource._internal(
        url, client, lastEventId, headers, body, method);
    await es._start();
    return es;
  }

  Future _start() async {
    _readyState = EventSourceReadyState.CONNECTING;
    var request = new http.Request(_method, url);
    request.headers["Cache-Control"] = "no-cache";
    request.headers["Accept"] = "text/event-stream";
    if (_lastEventId.isNotEmpty) {
      request.headers["Last-Event-ID"] = _lastEventId;
    }
    if (headers != null) {
      headers.forEach((k, v) {
        request.headers[k] = v;
      });
    }
    request.body = _body;

    var response = await client.send(request);

    if (response.statusCode != 200) {
      // server returned an error
      var bodyBytes = await response.stream.toBytes();
      String body = _encodingForHeaders(response.headers).decode(bodyBytes);
      throw new EventSourceSubscriptionException(response.statusCode, body);
    }
    _readyState = EventSourceReadyState.OPEN;
    response.stream.transform(_decoder).listen((Event event) {
      if (!_streamController.isClosed) {
        _streamController.add(event);
        _lastEventId = event.id;
      }
    },
        cancelOnError: true,
        onError: _retry,
        onDone: () => _readyState = EventSourceReadyState.CLOSED);
  }

  /// Retries until a new connection is established. Uses exponential backoff.
  Future _retry(dynamic e) async {
    _readyState = EventSourceReadyState.CONNECTING;
    // try reopening with exponential backoff
    Duration backoff = _retryDelay;
    while (true) {
      await new Future.delayed(backoff);
      try {
        await _start();
        break;
      } catch (error) {
        if (!_streamController.isClosed) {
          _streamController.addError(error);
        }

        backoff *= 2;
      }
    }
  }

  void _updateRetryDelay(Duration retry) {
    _retryDelay = retry;
  }

  void close() {
    client.close();
    _streamController.close();
  }

  // proxy the listen call to the controller's listen call
  @override
  StreamSubscription<Event> listen(void onData(Event event),
          {Function onError, void onDone(), bool cancelOnError}) =>
      _streamController.stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}

/// Returns the encoding to use for a response with the given headers. This
/// defaults to [LATIN1] if the headers don't specify a charset or
/// if that charset is unknown.
Encoding _encodingForHeaders(Map<String, String> headers) =>
    encodingForCharset(_contentTypeForHeaders(headers).parameters['charset']);

/// Returns the [MediaType] object for the given headers's content-type.
///
/// Defaults to `application/octet-stream`.
MediaType _contentTypeForHeaders(Map<String, String> headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return new MediaType.parse(contentType);
  return new MediaType("application", "octet-stream");
}
