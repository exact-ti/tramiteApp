import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Entity/Buzon.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();
*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  get refreshToken {
    return _prefs.getString('refresh_token') ?? '';
  }

  set refreshToken(String value) {
    _prefs.setString('refresh_token', value);
  }
  
  get buzones {
    return _prefs.getString("buzones");
  }

  set buzones(List<Buzon> buzones) {
    _prefs.setString("buzones", json.encode(buzones));
  }


  

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

}

