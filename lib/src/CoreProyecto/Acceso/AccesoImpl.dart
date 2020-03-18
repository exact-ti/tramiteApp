

import 'package:tramiteapp/src/Entity/Buzon.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  
  
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;
  IBuzonProvider buzonProvider;

  AccesoImpl(LogeoInterface logeo) {
    this.logeo = logeo;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async{
        Map<String, dynamic> interfaceLogear = await logeo.login(username, password);
        _prefs.token = interfaceLogear['access_token'];
        // List<Buzon> buzones = await buzonProvider.listarBuzonesDelUsuarioAutenticado();
        // _prefs.buzones = buzones;
        return interfaceLogear;
  
  }
}
