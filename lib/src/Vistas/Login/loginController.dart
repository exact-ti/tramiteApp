import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/INotification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/Notification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/NotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';
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
import 'package:tramiteapp/src/services/Service-Background/BackgroundService.dart';
import 'package:tramiteapp/src/services/Service-Background/service-notificaciones/NotificacionesBack.dart';
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

  INotificationCore notificationCore = new NotificationCore(
      new NotificacionProvider(),
      NotificacionPush.getInstance(new NotificacionProvider()));
  INotificationPush notificationPushCore =
      NotificacionPush.getInstance(new NotificacionProvider());

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
        BackgroundService.startBackground();
        NotificacionBack.instance()
            .startServerSentEvent(EstadoAppEnum.APP_OPEN);
        _prefs.estadoAppOpen = true;
        for (Menu men in listmenu) {
          if (men.home) {
            _navigationService.goBack();
            if (_prefs.tipoperfil == TipoPerfilEnum.TIPO_PERFIL_CLIENTE) {
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
    NotificacionBack.instance().startServerSentEvent(EstadoAppEnum.APP_OPEN);
    notificationPushCore.cerrarNotificacionPush();
    _prefs.estadoAppOpen = true;
    if (!_prefs.openByNotificationPush) {
      print("ENTRO CLIENTE");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/menuBottom', (Route<dynamic> route) => false);
    } else {
      _prefs.openByNotificationPush = false;
      _navigationService.setCantidadNotificacionBadge(0);
    }
  }

  openAppPerfilOperativo(BuildContext context) async {
    UtdModel utdModel = obtenerUTD();
    Provider.of<NotificationInfo>(context, listen: false).nombreUsuario =
        utdModel.nombre;
    NotificacionBack.instance().startServerSentEvent(EstadoAppEnum.APP_OPEN);
    _prefs.estadoAppOpen = true;
    notificationPushCore.cerrarNotificacionPush();
    if (!_prefs.openByNotificationPush) {
      print("ENTRO OPERATIVO");
      print("PRIMERO ES LOGINCONTROLLER");
      Navigator.of(context).pushNamedAndRemoveUntil(
          rutaPrincipal(), (Route<dynamic> route) => false);
    } else {
      _prefs.openByNotificationPush = null;
      _navigationService.setCantidadNotificacionBadge(0);
    }
  }
}
