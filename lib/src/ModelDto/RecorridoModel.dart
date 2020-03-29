class RecorridoModel {
  int id;
  String nombre;
  String horaInicio;
  String horaFin;
  String usuario;

    RecorridoModel({
        this.id,
        this.nombre = '',
        this.horaInicio = '',
        this.horaFin = '',
        this.usuario = '',
    });

    List<RecorridoModel> fromJson(List< dynamic> jsons){
       List<RecorridoModel> recorridos= new List();
        for(Map<String, dynamic> json in jsons){
           RecorridoModel recorrido = new RecorridoModel();
            recorrido.id  = json["id"];
            recorrido.nombre = json["nombre"];
            recorrido.horaInicio = json["horaInicio"];
            recorrido.horaFin = json["horaFin"];
            recorrido.usuario = json["usuario"];
            recorridos.add(recorrido);
        }
          return recorridos;
    }

    RecorridoModel fromJsonID(dynamic json){
           RecorridoModel recorrido = new RecorridoModel();
            recorrido.id  = json["id"];
          return recorrido;
    }

}