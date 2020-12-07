import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoFusionAuth.dart';
import 'package:tramiteapp/src/Providers/buzones/impl/BuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/impl/ConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/impl/MenuProvider.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/perfiles/impl/PerfilProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';
import 'package:tramiteapp/src/Providers/utds/impl/UtdProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesController.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'dart:convert';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';

class LoginController {
  AccesoInterface accesoInterface = new AccesoImpl(
      new LogeoFusionAuth(),
      new BuzonProvider(),
      new MenuProvider(),
      new ConfiguracionProvider(),
      new UtdProvider(),
      new NotificacionProvider(),
      new PerfilProvider());
  NotificacionInterface notificacionCore = NotificacionImpl.getInstance(new NotificacionProvider());
  SseInterface sseInterface = new SseImpl(new SseProvider());
  NotificacionModel notificacionModel = new NotificacionModel();
  NotificacionController notificacioncontroller = new NotificacionController();
  SharedPreferences sharedPreferences;

  final _prefs = new PreferenciasUsuario();
  final NavigationService _navigationService = locator<NavigationService>();

  validarlogin(BuildContext context, String username, String password) async {
    _navigationService.showModal();
    dynamic respuesta =
        await accesoInterface.login(username, password, context);
    if (respuesta["status"] != "success") {
      Navigator.pop(context);
      notificacion(context, "error", "EXACT", respuesta["message"]);
    } else {
      if (respuesta.containsKey("error")) {
        Navigator.pop(context);
        notificacion(context, "error", "EXACT", respuesta["mensaje"]);
      } else {
        Menu menuu = new Menu();
        _navigationService.inicializarProvider();
        List<dynamic> menus = json.decode(_prefs.menus);
        List<Menu> listmenu = menuu.fromPreferencs(menus);
        List<NotificacionModel> listanotificacionesPendientes = await notificacionCore.listarNotificacionesPendientes();
        Provider.of<NotificationInfo>(context, listen: false)
                .cantidadNotificacion =
            listanotificacionesPendientes
                .where((element) =>
                    element.notificacionEstadoModel.id == pendiente)
                .toList()
                .length;
        notificacionCore.inicializarStreamNotification();
        for (Menu men in listmenu) {
          if (men.home) {
            _navigationService.goBack();
            if (_prefs.tipoperfil == cliente) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/menuBottom', (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  men.link, (Route<dynamic> route) => false);
            }
          }
        }
      }
    }
  }

  openAppPerfilCliente(BuildContext context) async {
    BuzonModel buzonModel = buzonPrincipal();
    Provider.of<NotificationInfo>(context, listen: false).nombreUsuario =
        buzonModel.nombre;
    List<NotificacionModel> listanotificacionesPendientes =
        await notificacionCore.listarNotificacionesPendientes();
    Provider.of<NotificationInfo>(context, listen: false).cantidadNotificacion =
        listanotificacionesPendientes
            .where((element) => element.notificacionEstadoModel.id == pendiente)
            .toList()
            .length;
    notificacionCore.inicializarStreamNotification();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/menuBottom', (Route<dynamic> route) => false);
  }

  openAppPerfilOperativo(BuildContext context) async {
    UtdModel utdModel = obtenerUTD();
    Provider.of<NotificationInfo>(context, listen: false).nombreUsuario =
        utdModel.nombre;
    List<NotificacionModel> listanotificacionesPendientes =
        await notificacionCore.listarNotificacionesPendientes();
    Provider.of<NotificationInfo>(context, listen: false).cantidadNotificacion =
        listanotificacionesPendientes
            .where((element) => element.notificacionEstadoModel.id == pendiente)
            .toList()
            .length;
    notificacionCore.inicializarStreamNotification();
    Navigator.of(context).pushNamedAndRemoveUntil(
        rutaPrincipal(), (Route<dynamic> route) => false);
  }
}
