import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tramiteapp/src/routes/routes.dart';
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
      if (widget.rutaPage == "/") {
        menuinicio = "/dashboard";
      } else {
        menuinicio = widget.rutaPage;
/*         if (widget.rutaPage == "/envios-activos") {
          dataEnvio = widget.datainfo;
        } */
      }
      int ordenprueba = listmen
          .where((element) => element.link == menuinicio)
          .map((e) => e.orden - 1)
          .toList()
          .first;
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
          routes: getAplicationRoutes(
              menuinicio == "/envios-activos" ? dataEnvio : null),
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
