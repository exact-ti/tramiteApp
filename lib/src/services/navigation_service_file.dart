import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class NavigationService { 

  final GlobalKey<NavigatorState> navigatorKey =  new GlobalKey<NavigatorState>();

  Future <dynamic> navigationTo(String routeName) { 
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false); 
  }

  modelInformativo(String titulo,String mensaje) { 
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentState.overlay.context, // Using overlay's context
      builder: (context) {
        return AlertDialog(
          title: Text('$titulo'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
              eliminarpreferences(null);
              this.navigationTo('/login');
              }

            )
          ],
        );
      }
  );
  } 

}