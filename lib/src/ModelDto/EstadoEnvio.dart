class EstadoEnvio {
  int id;
  String nombre;

  EstadoEnvio({
    this.id,
    this.nombre = '',
  });

  EstadoEnvio fromOneJson(dynamic json) {
    EstadoEnvio estado = new EstadoEnvio();
    estado.id = json["id"];
    estado.nombre = json["nombre"];
    return estado;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}