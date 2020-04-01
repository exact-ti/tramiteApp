class EntregaModel {
  int id;
  String estado;
  String usuario;
  String nombreTurno;

    EntregaModel({
        this.id,
        this.estado = '',
        this.usuario = '',
        this.nombreTurno = '',
    });

    List<EntregaModel> fromJson(List< dynamic> jsons){
       List<EntregaModel> entregas= new List();
        for(Map<String, dynamic> json in jsons){
           EntregaModel men = new EntregaModel();
            men.id  = json["id"];
            men.estado = json["estado"];
            men.usuario = json["usuario"];
            men.nombreTurno = json["nombreTurno"];
            entregas.add(men);
        }
          return entregas;
    }

}