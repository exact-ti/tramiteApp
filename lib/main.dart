import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/routes/routes.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
 
void main() async { 
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
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