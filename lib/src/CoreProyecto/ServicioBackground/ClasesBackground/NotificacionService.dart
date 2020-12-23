import 'package:eventsource/eventsource.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Configuration/config.dart';
import 'NotificacionNotifier.dart';

class NotificacionService {
  
  factory NotificacionService.instance() => _instance;

  NotificacionService._internal();

  static final _instance = NotificacionService._internal();

  final _notificacionNotifier = NotificacionNotifier();

  ValueListenable<String> get serverData => _notificacionNotifier.dataNotifier;

/*   void startCounting() {
    Stream.periodic(Duration(seconds: 1)).listen((_) {
      _counter.increment();
      print('Counter incremented: ${_counter.count.value}');
    });
  } */

  void startServerSentEvent() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> header = {
      'Authorization': prefs.getString('token'),
    };
    EventSource eventSource = await EventSource.connect(properties['API'] +"/servicio-tramite/notificaciones/sse", headers: header);
    eventSource.listen((event) { 
      _notificacionNotifier.setInformation("SET AUTORIZATION : "+ "TIPOPERFIL : "+ prefs.getInt('tipoperfil').toString() + " TOKEN : " +event.data);
      print("AUTORIZACION : "+event.data);
    });
  }
}
