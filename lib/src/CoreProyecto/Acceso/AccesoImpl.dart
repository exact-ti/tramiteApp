import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoBuzonEnum.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Providers/configuraciones/IConfiguracionProvider.dart';
import 'package:tramiteapp/src/Providers/menus/IMenuProvider.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/INotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/perfiles/IPerfilProvider.dart';
import 'package:tramiteapp/src/Providers/utds/IUtdProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;
  IBuzonProvider buzonProvider;
  IMenuProvider menuProvider;
  IConfiguracionProvider configuracionProvider;
  IUtdProvider utdProvider;
  INotificacionProvider notificacionProvider;
  IPerfilProvider perfilProvider;
  AccesoImpl(
      LogeoInterface logeo,
      IBuzonProvider buzon,
      IMenuProvider menu,
      IConfiguracionProvider configuracion,
      IUtdProvider utdProvider,
      INotificacionProvider notificacionProvider,
      IPerfilProvider perfilProvider) {
    this.logeo = logeo;
    this.menuProvider = menu;
    this.buzonProvider = buzon;
    this.configuracionProvider = configuracion;
    this.utdProvider = utdProvider;
    this.notificacionProvider = notificacionProvider;
    this.perfilProvider = perfilProvider;
  }

  @override
  Future<Map<String, dynamic>> login(
      String username, String password, BuildContext context) async {
    dynamic authResponse = await logeo.login(username, password);
    if (authResponse["status"] == "success") {
      dynamic authData = authResponse["data"];
      _prefs.token = authData['access_token'];
      _prefs.refreshToken = authData['refresh_token'];
      _prefs.perfil = authData['perfilId'].toString();
      dynamic tipoPerfil = await perfilProvider.listarTipoPerfilByPerfil();
      _prefs.tipoperfil = tipoPerfil['id'];
      List<BuzonModel> buzones =
          await buzonProvider.listarBuzonesDelUsuarioAutenticado();
      _prefs.buzones = buzones;
      for (BuzonModel buzon in buzones) {
        if (buzon.tipoBuzon.id == personal) {
          HashMap<String, dynamic> buzonhash = new HashMap();
          buzonhash['id'] = buzon.id;
          buzonhash['nombre'] = buzon.nombre;
          _prefs.buzon = buzonhash;
        }
      }

      List<UtdModel> utds = await utdProvider.listarUtdsDelUsuarioAutenticado();
      _prefs.utds = utds;
      for (UtdModel utd in utds) {
        if (utd.principal) {
          HashMap<String, dynamic> utdhash = new HashMap();
          utdhash['id'] = utd.id;
          utdhash['nombre'] = utd.nombre;
          utdhash['principal'] = utd.principal;
          _prefs.utd = utdhash;
        }
      }

      if (_prefs.tipoperfil == cliente) {
        if (_prefs.buzon == null) {
          deletepreferencesWithoutContext();
          return {
            "error": "error",
            "mensaje": "Ha ocurrido un problema en el servidor"
          };
        } else {
          BuzonModel buzonModel = buzonPrincipal();
          Provider.of<NotificationInfo>(context, listen: false).nombreUsuario =
              buzonModel.nombre;
        }
      } else {
        if (_prefs.utd == null) {
          deletepreferencesWithoutContext();
          return {
            "error": "error",
            "mensaje": "Ha ocurrido un problema en el servidor"
          };
        } else {
          UtdModel utdModel = obtenerUTD();
          Provider.of<NotificationInfo>(context, listen: false).nombreUsuario =
              utdModel.nombre;
        }
      }

      List<Menu> menus = await menuProvider.listarMenusDelUsuarioAutenticado();
      _prefs.menus = menus;

      List<ConfiguracionModel> configuraciones =
          await configuracionProvider.listarConfiguraciones();
      _prefs.configuraciones = configuraciones;

      return authResponse;
    } else {
      return authResponse;
    }
  }
}
