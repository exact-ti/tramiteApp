class PalomarModel {
  int id;
  String codigo;
  int fila;
  int columna;
  String ubicacion;
  String tipo;

  PalomarModel({
    this.id,
    this.fila,
    this.columna,
    this.codigo = '',
  });

  PalomarModel fromOneJson(dynamic json) {
    PalomarModel palomar = new PalomarModel();
    palomar.id = json["id"];
    palomar.codigo = json["codigo"];
    palomar.fila = json["fila"];
    palomar.ubicacion = json["ubicacion"];
    dynamic tipopalomar = json["tipoPalomar"];
    palomar.tipo = tipopalomar["nombre"];
    return palomar;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fila": fila,
        "codigo": codigo,
        "columna": columna,
      };
}
