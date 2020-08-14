class DetalleRutaModel {
  int id;
  String remitente;
  String destinatario;
  String paqueteId;
  String estado;

  List<DetalleRutaModel> detalleRutafromJson(List<dynamic> jsons) {
    List<DetalleRutaModel> detalleruta = new List();
    for (Map<String, dynamic> json in jsons) {
      DetalleRutaModel ruta = new DetalleRutaModel();
      ruta.id = json["id"];
      ruta.remitente = json["remitente"];
      ruta.destinatario = json["destinatario"];
      ruta.paqueteId = json["paqueteId"];
      ruta.estado = json["paqueteId"];
      detalleruta.add(ruta);
    }
    return detalleruta;
  }
}
