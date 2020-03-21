
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoFusionAuth.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/impl/ConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/impl/MenuProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

class LoginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoFusionAuth(), new BuzonProvider(),new MenuProvider(), new ConfiguracionProvider());
      final _prefs = new PreferenciasUsuario();

    validarlogin(BuildContext context, String username , String password) {
        print("adsa");
        accesoInterface.login( username , password).then((data){
          print(data);
          if(data==null){
          mostrarAlerta(context, 'El usuario y contraseña son incorrectos');
          }else{
          Menu menuu = new Menu();
          List<dynamic> menus = json.decode(_prefs.menus);
          List<Menu> listmenu = menuu.fromPreferencs(menus);
            for (Menu men in listmenu) {
                  if(men.home){
                  Navigator.of(context).pushNamed(men.link);
                  }
              }
          }
        });
    }

}
