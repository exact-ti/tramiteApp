/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Home/SecondPage.dart';
import 'package:tramiteapp/src/Vistas/Home/firstPage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  PageController pageController = PageController();
  final List<Widget> _childrenPages = [
    FistPage(),
    SecondPage(),
    HomePage(),
    HomePage(),
    FistPage(),
    SecondPage(),
    HomePage(),
  ];


  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: /* _children[currentIndex] */PageView(
        children:_childrenPages,
        controller: pageController,
        onPageChanged: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          onTap: onTappedBar,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text("Search"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.remove_circle_outline),
                title: Text("delete"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.check),
                title: Text("Confirmar"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text("Perfil"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text("Perfil"),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text("Perfil"),
                backgroundColor: Colors.blue),
          ]),
    );
  }
}
 */


/* import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'SecondPage.dart';
import 'firstPage.dart';

class TopLevelWidget extends StatefulWidget {
  @override
  _TopLevelWidgetState createState() => _TopLevelWidgetState();
}

class _TopLevelWidgetState extends State<TopLevelWidget> {
  final navigatorKey = GlobalKey<NavigatorState>();
  PageController pageController = PageController();

  int currentIndex = 0;

  final pagesRouteFactories = {
    "/": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => FistPage()),
    "takeOff": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => HomePage()),
    "landing": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => SecondPage()),
    "settings": () => PageRouteBuilder(pageBuilder: (_, a1, a2) => HomePage()),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        ),
      );

  Widget _buildBody() => MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (route) => pagesRouteFactories[route.name]());

  Widget _buildBottomNavigationBar(context) => BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      items: [
        _buildBottomNavigationBarItem("Home", Icons.home),
        _buildBottomNavigationBarItem("Take Off", Icons.flight_takeoff),
        _buildBottomNavigationBarItem("Landing", Icons.flight_land),
        _buildBottomNavigationBarItem(
          "Settings",
          Icons.settings,
        )
      ],
      onTap: (routeIndex) {
        setState(() {
          currentIndex = routeIndex;
        });
        navigatorKey.currentState
            .pushNamed(pagesRouteFactories.keys.toList()[routeIndex]);
      });

  _buildBottomNavigationBarItem(name, icon) => BottomNavigationBarItem(
      icon: Icon(icon), title: Text(name), backgroundColor: Colors.black45);
} */
