class EntregaModel {
  int id;
  String estado;
  String usuario;
  String nombreRecorrido;

    EntregaModel({
        this.id,
        this.estado = '',
        this.usuario = '',
        this.nombreRecorrido = '',
    });

    List<EntregaModel> fromJson(List< dynamic> jsons){
       List<EntregaModel> entregas= new List();
        for(Map<String, dynamic> json in jsons){
           EntregaModel men = new EntregaModel();
            men.id  = json["id"];
            men.estado = json["estado"];
            men.usuario = json["usuario"];
            men.nombreRecorrido = json["nombreRecorrido"];
            entregas.add(men);
        }
          return entregas;
    }

}