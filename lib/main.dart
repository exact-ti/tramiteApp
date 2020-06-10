import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/routes/routes.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;


 
void main() async { 
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  tz.initializeTimeZones();
  print(timezone.parse('2020-06-10 13:56'));
  setupLocator();
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Componentes App',
      debugShowCheckedModeBanner: false,
      //home: HomePage()
      initialRoute: '/login',  
      routes: getAplicationRoutes(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) =>LoginPage()
        );
      },
      navigatorKey: locator<NavigationService>().navigatorKey
    );
  }
}