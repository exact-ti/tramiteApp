import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Vistas/Dashboard-Cliente/dashboardPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioConfirmadoPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Historicos/HistoricoPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';
import 'MenuController.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class TopLevelWidget extends StatefulWidget {
  final String rutaPage;
  final dynamic datainfo;
  TopLevelWidget({this.rutaPage, this.datainfo});
  @override
  _TopLevelWidgetState createState() => _TopLevelWidgetState();
}

class _TopLevelWidgetState extends State<TopLevelWidget> {
  final navigatorKey = GlobalKey<NavigatorState>();
  MenuController menuController = new MenuController();
  int currentIndex = 0;
  Menu menuu = new Menu();
  List<Menu> listMenu = new List();
  String menuinicio = "";
  dynamic dataEnvio;

  @override
  void initState() {
    dataEnvio = widget.datainfo;
    listarMenuBottomNavBar();
    super.initState();
  }

  void listarMenuBottomNavBar() async {
    List<Menu> listmen = listMenuUtil();
    if (widget.rutaPage != null) {
      int ordenprueba = 0;
      if (widget.rutaPage == "/") {
        menuinicio = "/dashboard";
      } else {
        if (widget.rutaPage == "/notificaciones") {
          menuinicio = "/notificaciones";
          ordenprueba = 0;
        } else {
          menuinicio = widget.rutaPage;
          ordenprueba = listmen
              .where((element) => element.link == menuinicio)
              .map((e) => e.orden - 1)
              .toList()
              .first;
        }
      }
      if (this.mounted) {
        setState(() {
          listMenu = listmen;
          menuinicio = menuinicio;
          currentIndex = ordenprueba;
        });
      }
    } else {
      menuinicio = listmen
          .where((element) => element.home)
          .map((e) => e.link)
          .toList()
          .first;
      if (this.mounted) {
        setState(() {
          menuinicio = menuinicio;
          listMenu = listmen;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    Widget _buildBody() => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: menuinicio,
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('en'), const Locale('es')],
/*           routes: {
            "/": (_) => DashboardPage(),
          }, */
          onGenerateRoute: (settings) {
            if (settings.name == "/") {
              return null;
            }
            if (settings.name == "/generar-envio") {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => PrincipalPage(),
                  transitionDuration: Duration(milliseconds: 0));
            }
            if (settings.name == "/envios-historicos") {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HistoricoPage(),
                  transitionDuration: Duration(milliseconds: 0));
            }
            if (settings.name == '/envios-activos') {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ListarEnviosActivosPage(
                      objetoModo:
                          menuinicio == "/envios-activos" ? dataEnvio : null),
                  transitionDuration: Duration(milliseconds: 0));
            }
            if (settings.name == '/confirmar-envios') {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => RecepcionEnvioPage(),
                  transitionDuration: Duration(milliseconds: 0));
            }
            if (settings.name == '/crear-envio') {
              UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
              dynamic usuario = settings.arguments;
              usuarioFrecuente.area = usuario['area'];
              usuarioFrecuente.id = usuario['id'];
              usuarioFrecuente.nombre = usuario['nombre'];
              usuarioFrecuente.sede = usuario['sede'];
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => EnvioPage(
                        usuariopage: usuarioFrecuente,
                      ),
                  transitionDuration: Duration(milliseconds: 0));
            }
            if (settings.name == '/envio-confirmado') {
              UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
              dynamic usuario = settings.arguments;
              usuarioFrecuente.area = usuario['area'];
              usuarioFrecuente.id = usuario['id'];
              usuarioFrecuente.nombre = usuario['nombre'];
              usuarioFrecuente.sede = usuario['sede'];
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => EnvioConfirmadoPage(
                        usuariopage: usuarioFrecuente,
                      ),
                  transitionDuration: Duration(milliseconds: 0));
            }

            return MaterialPageRoute(builder: (_) => DashboardPage());
          },
        );

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
        unselectedFontSize: 10,
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

          if (nombre == "/envios-activos") {
            setState(() {
              dataEnvio = null;
            });
          }

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
