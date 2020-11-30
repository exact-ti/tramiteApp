import 'dart:collection';
import 'dart:convert';

import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class BuzonImpl implements BuzonInterface {
  IBuzonProvider buzonProvider;
  final _prefs = new PreferenciasUsuario();
  BuzonModel buzonModel = new BuzonModel();

  BuzonImpl(IBuzonProvider buzonProvider) {
    this.buzonProvider = buzonProvider;
  }

  @override
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    return await buzonProvider.listarBuzonesPorIds(ids);
  }

  @override
  Future<List<BuzonModel>> listarBuzones() async {
    return await buzonProvider.listarBuzonesDelUsuarioAutenticado();
  }

  @override
  String obtenerNombreBuzonById(int buzonId) {
    List<dynamic> buzonCore = json.decode(_prefs.buzones);
    List<BuzonModel> listBuzones = buzonModel.listfromPreferencs(buzonCore);
    return listBuzones.firstWhere((buzon) => buzon.id == buzonId).nombre;
  }

  @override
  void changeBuzonById(int buzonId) {
    BuzonModel buzonActual = listarBuzonPrincipal();
    if (buzonActual.id != buzonId) {
      BuzonModel buzonNuevo = listarBuzonById(buzonId);
      HashMap<String, dynamic> buzonNuevoMap = new HashMap();
      buzonNuevoMap['id'] = buzonNuevo.id;
      buzonNuevoMap['nombre'] = buzonNuevo.nombre;
      _prefs.buzon = buzonNuevoMap;
    }
  }

  @override
  BuzonModel listarBuzonPrincipal() {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    return buzonModel.fromPreferencs(buzon);
  }

  @override
  BuzonModel listarBuzonById(int buzonId) {
    List<dynamic> buzonCore = json.decode(_prefs.buzones);
    List<BuzonModel> buzones = buzonModel.listfromPreferencs(buzonCore);
    return buzones.firstWhere((buzon) => buzon.id == buzonId);
  }
}
