import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoFusionAuth.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/impl/ConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/impl/MenuProvider.dart';
import 'package:tramiteapp/src/Providers/utds/impl/UtdProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'dart:convert';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class LoginController {
  AccesoInterface accesoInterface = new AccesoImpl(
      new LogeoFusionAuth(),
      new BuzonProvider(),
      new MenuProvider(),
      new ConfiguracionProvider(),
      new UtdProvider());
  final _prefs = new PreferenciasUsuario();
  final NavigationService _navigationService = locator<NavigationService>();

  validarlogin(BuildContext context, String username, String password) async {
    _navigationService.showModal();
    dynamic respuesta = await accesoInterface.login(username, password);
    if (respuesta == null) {
      Navigator.pop(context);
      notificacion(
          context, "error", "EXACT", 'Usuario y/o contraseña incorrecta');
    } else {
      if (respuesta.containsKey("error")) {
         Navigator.pop(context);
      notificacion(
          context, "error", "EXACT", respuesta["mensaje"]);
      } else {
        Menu menuu = new Menu();
        List<dynamic> menus = json.decode(_prefs.menus);
        List<Menu> listmenu = menuu.fromPreferencs(menus);
        for (Menu men in listmenu) {
          if (men.home) {
            _navigationService.goBack();
            Navigator.of(context).pushNamedAndRemoveUntil(
                men.link, (Route<dynamic> route) => false);
          }
        }
      }
    }
  }
}
