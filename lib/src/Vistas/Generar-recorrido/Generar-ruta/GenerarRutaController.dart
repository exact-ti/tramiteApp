import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/INotification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Notification/Notification.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/INotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificationPush/NotificationPush.core.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaInterface.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';

class GenerarRutaController {
  RutaInterface rutaInterface = new RutaImpl(new RutaProvider());
  final NavigationService _navigationService = locator<NavigationService>();
  INotificationCore notificationCore = new NotificationCore(new NotificacionProvider(), NotificacionPush.getInstance(new NotificacionProvider()));
  INotificationPush notificationPushCore = NotificacionPush.getInstance(new NotificacionProvider());
  

  Future<List<RutaModel>> listarMiRuta(int recorridoId) async {
    List<RutaModel> entregas = await rutaInterface.listarMiruta(recorridoId);
    return entregas;
  }

  void notificarMasivoRecojo(int recorridoId,BuildContext context) async {
    _navigationService.showModal();
    dynamic response = await notificationPushCore.notificarMasivoRecojo(recorridoId);
    _navigationService.goBack();
    if (response["status"] == "success") {
        notificacion(context, "success", "EXACT", "Se realizó la notificación");
    } else {
        notificacion(context, "error", "EXACT", "No se pudo realizar la notificación");
    }
  }

  void opcionRecorrido(
      int recorridoId, int indicepagina, BuildContext context) async {
    bool recorrido =
        await rutaInterface.opcionRecorrido(recorridoId, indicepagina);
    if (recorrido) {
      if (indicepagina == 1) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/entrega-regular', ModalRoute.withName('/recorridos'),
            arguments: {
              'recorridoId': recorridoId,
            });
      } else {
        bool respuestatrue = await notificacion(
            context, "success", "EXACT", "Se completó el recorrido con éxito");
        if (respuestatrue) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/recorridos',
            (Route<dynamic> route) => false,
          );
        }
      }
    } else {
      notificacion(
          context, "error", "EXACT", "No se pudo terminar el recorrido");
    }
  }
}
