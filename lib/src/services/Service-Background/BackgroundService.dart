import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../locator.dart';
import 'service-notificaciones/NotificacionesBack.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;

void backgroundMain() async {
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  tz.initializeTimeZones();
  print(timezone.parse('2020-06-10 13:56'));
  setupLocator();
  prefs.estadoAppOpen = false;
  Provider.debugCheckInvalidValueType = null;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getString("token") != null) {
    NotificacionBack.instance().startServerSentEvent(EstadoAppEnum.APP_CLOSE);
  }
}
