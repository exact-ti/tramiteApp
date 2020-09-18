
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/SseCore/SseInterface.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/sseProvider/impl/SseProvider.dart';

class AppBarController {
  SseInterface sseInterface = new SseImpl(new SseProvider());
  NotificacionInterface notificacionCore =
      new NotificacionImpl(new NotificacionProvider());


  List<NotificacionModel> listanotificaciones = [];
  AppBarController() {
    /* esucharnotificaciones2(); */
  }
  Future<Stream<List<NotificacionModel>>> esucharnotificaciones() async {
    Stream<List<NotificacionModel>> entregas =
        await sseInterface.listarnotificaciones();
    return entregas;
  }

  Future<dynamic> verNotificaciones() async {
    dynamic notificacionrespuesta = await notificacionCore.verNotificaciones();
    return notificacionrespuesta;
  }

  Future<List<NotificacionModel>> listarNotificacionesPendientes() async {
    List<NotificacionModel> notificacionespendientes =
        await notificacionCore.listarNotificacionesPendientes();
    return notificacionespendientes;
  }

  void esucharnotificaciones2() {
    sseInterface.listarnotificaciones2().listen((event) {
      print(event);
      listanotificaciones = event;
    });
  }

  Stream<List<NotificacionModel>> esucharnotificaciones3() {
    Stream<List<NotificacionModel>> entregas =
        sseInterface.listarnotificaciones2();
    return entregas;
  }


}
