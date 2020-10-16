import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Vistas/Consulta-Envio/ConsultaEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/Listar-envios/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalPage.dart';
import 'package:tramiteapp/src/Vistas/Historicos/HistoricoPage.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';
import 'package:tramiteapp/src/Vistas/Retirar-Envio/RetirarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/dashboard/dashboardPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'MenuController.dart';

class TopLevelWidget extends StatefulWidget {
  final String rutaPage;
  TopLevelWidget({
    this.rutaPage,
  });
  @override
  _TopLevelWidgetState createState() => _TopLevelWidgetState();
}

class _TopLevelWidgetState extends State<TopLevelWidget> {
  final navigatorKey = GlobalKey<NavigatorState>();
  PageController pageController = PageController();
  MenuController menuController = new MenuController();
  int currentIndex = 0;
  Menu menuu = new Menu();
  List<Menu> listMenu = new List();
  String menuinicio = "";
  @override
  void initState() {
    listarMenuBottomNavBar();
    validarIngreso();
    super.initState();
  }

  validarIngreso() {
    if (widget.rutaPage != null) {
      if (this.mounted) {
        String rutaname = "";
        if (widget.rutaPage == "/") {
          rutaname = "/dashboard";
        } else {
          rutaname = widget.rutaPage;
        }
        int ordenprueba = listMenu
            .where((element) => element.link == rutaname)
            .map((e) => e.orden - 1)
            .toList()
            .first;
        setState(() { 
          currentIndex = ordenprueba;
        });
      }
    }
  }

  void listarMenuBottomNavBar() async {
    final _prefs = new PreferenciasUsuario();
    List<dynamic> menus = json.decode(_prefs.menus);
    List<Menu> listmenu = menuu.fromPreferencs(menus);
    listmenu.sort((a, b) => a.orden.compareTo(b.orden));
    listmenu.reversed;
    if (this.mounted) {
      setState(() {
        menuinicio = listmenu
            .where((element) => element.home)
            .map((e) => e.link)
            .toList()
            .first;
        listMenu = listmenu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    final pagesRouteFactories = {
      "/": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => DashboardPage()),
      "/home": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => HomePage()),
      "/notificaciones": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => NotificacionesPage()),
      "/confirmar-envios": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => RecepcionEnvioPage()),
      "/generar-envio": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => PrincipalPage()),
      "/consulta-envios": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => ConsultaEnvioPage()),
      "/envios-activos": () => PageRouteBuilder(
          pageBuilder: (_, a1, a2) => ListarEnviosActivosPage()),
      "/retirar-envio": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => RetirarEnvioPage()),
      "/envios-historicos": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => HistoricoPage()),
      "/dashboard": () =>
          PageRouteBuilder(pageBuilder: (_, a1, a2) => DashboardPage()),
    };

    Widget _buildBody() => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
        onGenerateRoute: (route) {
          return pagesRouteFactories[route.name]();
        });

    _buildBottomNavigationBarItem(name, icon) => BottomNavigationBarItem(
        icon: Icon(menuController.icons[icon]),
        title: Container(
            margin: const EdgeInsets.only(top: 3),
            child: Text(name.replaceAll(RegExp(' '), ' \n'),
                style: TextStyle(fontSize: 10), textAlign: TextAlign.center)),
        backgroundColor: Colors.black45);

    List<BottomNavigationBarItem> returnItems() {
      List<BottomNavigationBarItem> items = new List();
      for (Menu menu in listMenu) {
        items.add(_buildBottomNavigationBarItem(menu.nombre, menu.icono));
      }
      return items;
    }

    _buildBottomNavigationBar(context) => BottomNavigationBar(
        currentIndex: currentIndex,
        key: key,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        items: returnItems(),
        onTap: (routeIndex) {
          String nombre = listMenu
              .where((element) => element.orden == routeIndex + 1)
              .map((e) => e.link)
              .toList()
              .first;
          int routepasada = currentIndex;
          setState(() {
            currentIndex = routeIndex;
          });
          navigatorKey.currentState.pushNamed(nombre).whenComplete(() {
            setState(() {
              currentIndex = routepasada;
            });
          });
        });

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}
