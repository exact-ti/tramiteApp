

import 'package:tramiteapp/src/Entity/Buzon.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/menus/IMenuProvider.dart';
import 'package:tramiteapp/src/Providers/menus/impl/MenuProvider.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  
  
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;
  IBuzonProvider buzonProvider;
  IMenuProvider menuProvider;

  AccesoImpl(LogeoInterface logeo) {
    this.logeo = logeo;
    this.menuProvider = new MenuProvider();
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async{
        Map<String, dynamic> interfaceLogear = await logeo.login(username, password);
        if(interfaceLogear==null){
          return null;
        }
        _prefs.token = interfaceLogear['access_token'];
        // List<Buzon> buzones = await buzonProvider.listarBuzonesDelUsuarioAutenticado();
        // _prefs.buzones = buzones;

        List<Menu> menus = await menuProvider.listarMenusDelUsuarioAutenticado();
        _prefs.menus = menus;
        var log = "";
        return interfaceLogear;
  
  }
}
