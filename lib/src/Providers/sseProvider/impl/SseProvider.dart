import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../ISseProvider.dart';

class SseProvider implements ISseProvider {
  Requester req = Requester();
  NotificacionModel notificacionModel = new NotificacionModel();

  @override
  Future<EventSource> eventSourceList() async {
      EventSource response = await req.sseventSource("/servicio-tramite/notificaciones/sse");
      return response;
  }

}
