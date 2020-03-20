

import 'dart:collection';

import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/IConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/IMenuProvider.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  
  
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;
  IBuzonProvider buzonProvider;
  IMenuProvider menuProvider;
  IConfiguracionProvider configuracionProvider;

  AccesoImpl(LogeoInterface logeo, IBuzonProvider buzon, IMenuProvider menu, IConfiguracionProvider configuracion) {
    this.logeo = logeo;
    this.menuProvider = menu;
    this.buzonProvider = buzon;
    this.configuracionProvider = configuracion;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async{
        Map<String, dynamic> interfaceLogear = await logeo.login(username, password);
        if(interfaceLogear==null){
          return null;
        }

        _prefs.token = interfaceLogear['access_token'];

         List<BuzonModel> buzones = await buzonProvider.listarBuzonesDelUsuarioAutenticado();
         for (BuzonModel buzon in buzones) {
           if(buzon.tipoBuzon.nombre=="PERSONAL"){
             HashMap<String,dynamic> buzonhash = new HashMap();
             buzonhash['id'] = buzon.id;
             buzonhash['nombre'] = buzon.nombre;
            _prefs.buzon = buzonhash;
           }
         }

        List<Menu> menus = await menuProvider.listarMenusDelUsuarioAutenticado();
        _prefs.menus = menus;

        List<ConfiguracionModel> configuraciones = await configuracionProvider.listarConfiguraciones();
        _prefs.configuraciones = configuraciones;

        //List<UsuarioFrecuente> usuariosfrecuentes = await usuario.listarUsuarioFrecuenteDelUsuarioAutenticado();


        print("LL");
        return interfaceLogear;
  
  }
}
