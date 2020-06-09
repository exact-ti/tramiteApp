import 'package:flutter/widgets.dart';

class NavigationService { 

  final GlobalKey<NavigatorState> navigatorKey =  new GlobalKey<NavigatorState>();

  Future <dynamic> navigationTo(String routeName) { 
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false); 
  }
  bool goBack() { 
    return navigatorKey.currentState.pop (); 
  } 
}