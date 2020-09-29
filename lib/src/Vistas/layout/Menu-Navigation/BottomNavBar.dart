
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
