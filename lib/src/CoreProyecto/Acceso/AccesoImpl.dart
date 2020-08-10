

import 'dart:collection';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoBuzonEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/IConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/IMenuProvider.dart';
import 'package:tramiteapp/src/Providers/utds/IUtdProvider.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  
  //TipoBuzonEnum tipoBuzonEnum;
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;
  IBuzonProvider buzonProvider;
  IMenuProvider menuProvider;
  IConfiguracionProvider configuracionProvider;
  IUtdProvider utdProvider;  

  AccesoImpl(LogeoInterface logeo, IBuzonProvider buzon, IMenuProvider menu, IConfiguracionProvider configuracion,IUtdProvider utdProvider) {
    this.logeo = logeo;
    this.menuProvider = menu;
    this.buzonProvider = buzon;
    this.configuracionProvider = configuracion;
    this.utdProvider = utdProvider;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async{
        Map<String, dynamic> interfaceLogear = await logeo.login(username, password);
        if(interfaceLogear==null){
          return null;
        }

        if(!interfaceLogear.containsKey("error")){


        _prefs.token = interfaceLogear['access_token'];
        _prefs.refreshToken = interfaceLogear['refresh_token'];
        _prefs.perfil = interfaceLogear['perfilId'].toString();
       
/*         if(tipoPerfil(interfaceLogear['perfilId'].toString())==cliente){
 */         List<BuzonModel> buzones = await buzonProvider.listarBuzonesDelUsuarioAutenticado();
        _prefs.buzones = buzones;
         for (BuzonModel buzon in buzones) {
           if(buzon.tipoBuzon.id==personal){
             HashMap<String,dynamic> buzonhash = new HashMap();
             buzonhash['id'] = buzon.id;
             buzonhash['nombre'] = buzon.nombre;
            _prefs.buzon = buzonhash;
           }
         }
/*         }else{
 */         List<UtdModel> utds = await utdProvider.listarUtdsDelUsuarioAutenticado();
          _prefs.utds = utds;
         for (UtdModel utd in utds) {
           if(utd.principal){
             HashMap<String,dynamic> utdhash = new HashMap();
             utdhash['id'] = utd.id;
             utdhash['nombre'] = utd.nombre;
             utdhash['principal'] = utd.principal;             
            _prefs.utd = utdhash;
           }
         }
/*         }
 */        List<Menu> menus = await menuProvider.listarMenusDelUsuarioAutenticado();
        _prefs.menus = menus;

        List<ConfiguracionModel> configuraciones = await configuracionProvider.listarConfiguraciones();
        _prefs.configuraciones = configuraciones;

        return interfaceLogear;
                }else{
                  return null;
                }
  
  }
}
