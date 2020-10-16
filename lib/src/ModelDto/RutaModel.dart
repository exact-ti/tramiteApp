class RutaModel {
  int id;
  String codigo;
  String nombre;
  String ubicacion;
  int orden;
  int cantidadRecojo;
  int cantidadEntrega;
  //corregirarea
  List<RutaModel> fromJson(List<dynamic> jsons) {
    List<RutaModel> rutas = new List();
    for (Map<String, dynamic> json in jsons) {
      RutaModel ruta = new RutaModel();
      ruta.id = json["id"];
      ruta.codigo = json["codigo"];
      ruta.ubicacion = json["ubicacion"];
      ruta.nombre = json["nombre"];
      ruta.orden = json["orden"];
      ruta.cantidadRecojo = json["cantidadRecojo"];
      ruta.cantidadEntrega = json["cantidadEntrega"];
      rutas.add(ruta);
    }
    return rutas;
  }
}
