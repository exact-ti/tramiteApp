class NotificacionEstadoModel {
  String nombre;
  int id;

  NotificacionEstadoModel fromJsonToEstado(dynamic json) {
    NotificacionEstadoModel notificacionEstadoModel =
        new NotificacionEstadoModel();
    notificacionEstadoModel.id = json["id"];
    notificacionEstadoModel.nombre = json["nombre"];
    return notificacionEstadoModel;
  }
}
