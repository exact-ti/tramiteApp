import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'ClasesBackground/NotificacionService.dart';
import 'IServicioBackground.core.dart';

class ServicioBackgroundCore implements IServicioBackgroundCore {
  @override
  void inicializarNotificacionBackground() async {
    var channel = const MethodChannel('com.example/background_service');
    CallbackHandle codeCallbackHandle =
        PluginUtilities.getCallbackHandle(backgroundMain);
    channel.invokeMethod('startService', codeCallbackHandle.toRawHandle());
    NotificacionService.instance().startServerSentEvent();
  }
}

void backgroundMain() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificacionService.instance().startServerSentEvent();
}
