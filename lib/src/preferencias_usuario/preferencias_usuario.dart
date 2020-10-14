import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

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

  set token(String value) {
    _prefs.setString('token', value);
  }

  get refreshToken {
    return _prefs.getString('refresh_token') ?? '';
  }

  set refreshToken(String value) {
    _prefs.setString('refresh_token', value);
  }

  get perfil {
    return _prefs.getString('perfil') ?? '';
  }

  set perfil(String value) {
    _prefs.setString('perfil', value);
  }

  get tipoperfil {
    return _prefs.getInt('tipoperfil') ?? 0;
  }

  set tipoperfil(int value) {
    _prefs.setInt('tipoperfil', value);
  }

  get buzon {
    return _prefs.getString("buzon");
  }

  set buzon(HashMap<String, dynamic> buzon) {
    _prefs.setString("buzon", json.encode(buzon));
  }

  get utd {
    return _prefs.getString("utd");
  }

  set utd(HashMap<String, dynamic> utd) {
    _prefs.setString("utd", json.encode(utd));
  }

  get buzones {
    return _prefs.getString("buzones");
  }

  set buzones(List<BuzonModel> buzones) {
    _prefs.setString("buzones", json.encode(buzones));
  }

  get utds {
    return _prefs.getString("utds");
  }

  set utds(List<UtdModel> utds) {
    _prefs.setString("utds", json.encode(utds));
  }

  get menus {
    return _prefs.getString("menus");
  }

  set menus(List<Menu> menus) {
    _prefs.setString("menus", json.encode(menus));
  }

  get configuraciones {
    return _prefs.getString("configuraciones");
  }

  set configuraciones(List<ConfiguracionModel> configuraciones) {
    _prefs.setString("configuraciones", json.encode(configuraciones));
  }

  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }
}
