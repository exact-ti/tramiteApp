import 'package:flutter/material.dart';

class NotificationInfo with ChangeNotifier {

  int _cantidadNotificacion = 0;

  get cantidadNotificacion{
    return _cantidadNotificacion;
  }

  set cantidadNotificacion( int cantidad ) {
    this._cantidadNotificacion = cantidad;
    notifyListeners();
  }

}