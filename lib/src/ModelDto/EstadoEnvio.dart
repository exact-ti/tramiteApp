class EstadoEnvio {
  int id;
  String nombre;
  bool estado;

  EstadoEnvio fromOneJson(dynamic json) {
    EstadoEnvio estado = new EstadoEnvio();
    estado.id = json["id"];
    estado.nombre = json["nombre"];
    return estado;
  }

    List<EstadoEnvio> fromJsonToEnviosActivos(List<dynamic> jsons){
       List<EstadoEnvio> enviosEstado= new List();
        for(Map<String, dynamic> json in jsons){
           EstadoEnvio  envio = new EstadoEnvio();
            envio.id = json["id"];
            envio.nombre = json["nombre"];
            enviosEstado.add(envio);
        }
          return enviosEstado;
    }  


  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}