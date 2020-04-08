class PalomarModel {
  int id;
  String codigo;
  int fila;
  int columna;

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
    //palomar.id = json["fila"];
    //palomar.codigo = json["columna"];
    return palomar;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fila": fila,
        "codigo": codigo,
        "columna": columna,
      };
}
