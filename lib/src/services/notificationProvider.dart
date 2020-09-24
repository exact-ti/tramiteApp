import 'package:flutter/material.dart';

class NotificationInfo with ChangeNotifier {

  int _cantidadNotificacion = 0;

  int get cantidadNotificacion => this._cantidadNotificacion;

  set cantidadNotificacion( int cantidad ) {
    this._cantidadNotificacion = cantidad;
    notifyListeners();
  }

    int _estadoApp = 0;

  int get estadoApp => this._estadoApp;

  set estadoApp( int estado ) {
    this._estadoApp = estado;
    notifyListeners();
  }


  int _finalizarSubcripcion = 0;

  int get finalizarSubcripcion => this._finalizarSubcripcion;

  set finalizarSubcripcion( int estado ) {
    this._finalizarSubcripcion = estado;
    notifyListeners();
  }

}