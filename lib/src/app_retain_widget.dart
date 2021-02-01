import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class AppRetainWidget extends StatelessWidget {
  const AppRetainWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  final _channel = const MethodChannel('com.example/app_retain');

  @override
  Widget build(BuildContext context) {
      final _prefs = new PreferenciasUsuario();

    return WillPopScope(
      onWillPop: () async {
        _prefs.estadoAppOpen=false;
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return true;
          } else {
            _channel.invokeMethod('sendToBackground');
            return false;
          }
        } else {
          return true;
        }
      },
      child: child,
    );
  }
}
