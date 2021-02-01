import 'package:intl/intl.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;

import 'NotificacionEstadoModel.dart';

class NotificacionModel {
  String ruta;
  String mensaje;
  String fecha;
  NotificacionEstadoModel notificacionEstadoModel;
  int id;
  int buzonId;

  List<NotificacionModel> fromJsonToNotificacion(List<dynamic> jsons) {
    List<NotificacionModel> listnotificaciones = new List();
    NotificacionEstadoModel estadoModel = new NotificacionEstadoModel();
    for (Map<String, dynamic> json in jsons) {
      NotificacionModel notificacionModel = new NotificacionModel();
      notificacionModel.id = json["id"];
      notificacionModel.mensaje = json["mensaje"];
      notificacionModel.ruta = json["ruta"];
      notificacionModel.buzonId = json["buzonId"];
      notificacionModel.notificacionEstadoModel=estadoModel.fromJsonToEstado(json["estado"]);
      dynamic dateTimeZone = timezone.parse(json["fecha"]);
      notificacionModel.fecha = "$dateTimeZone";
      DateTime fecha =
          new DateFormat("yyyy-MM-dd hh:mm:ss").parse(notificacionModel.fecha);
      notificacionModel.fecha =
          DateFormat('dd-MM-yyyy hh:mm:ssa').format(fecha);
      listnotificaciones.add(notificacionModel);
    }
    return listnotificaciones;
  }
}
