class PalomarModel {
  String id;
  String codigo;
  String fila;
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
    palomar.fila = json["destino"];
    palomar.ubicacion = json["ubicacion"];
    palomar.tipo = json["tipoPalomar"];
    return palomar;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fila": fila,
        "codigo": codigo,
        "columna": columna,
      };
}
