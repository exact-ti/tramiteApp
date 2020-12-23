import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacionNotifier {

  NotificacionNotifier() { 
    _readNotifier().then((count) => _notifierNotificacion.value = count);
  }

  ValueNotifier<String> _notifierNotificacion = ValueNotifier("");

  ValueListenable<String> get dataNotifier => _notifierNotificacion;

  void setInformation(String dataSSE) {
    _notifierNotificacion.value = _notifierNotificacion.value + " " + dataSSE;
    _writeNotifier(_notifierNotificacion.value);
  }

  Future<String> _readNotifier() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('dataSSE') ?? "";
  }

  Future<void> _writeNotifier(String dataSSE) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString("dataSSE",dataSSE);
  }
}
