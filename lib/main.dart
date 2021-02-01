import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/app_retain_widget.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/routes/routes.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';



void main() async {
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await prefs.initPrefs();
  tz.initializeTimeZones();
  print(timezone.parse('2020-06-10 13:56'));
  setupLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(MyApp()),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => new NotificationInfo(),
        child: MaterialApp(
            title: 'Componentes App', 
            debugShowCheckedModeBanner: false,
            home:   AppRetainWidget ( child:  LoginPage(), ), 
            routes: getAplicationRoutes(null),
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [const Locale('en'), const Locale('es')],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                  builder: (BuildContext context) =>LoginPage());
            },
            navigatorKey: locator<NavigationService>().navigatorKey));
  }
}
