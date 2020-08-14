
class TipoEntregaPersonalizadaModel {
  int id;
  String descripcion;
  bool estado;

    TipoEntregaPersonalizadaModel({
        this.id,
        this.descripcion='',
        this.estado = true
    });

    List<TipoEntregaPersonalizadaModel> fromJson(List< dynamic> jsons){
       List<TipoEntregaPersonalizadaModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           TipoEntregaPersonalizadaModel  envio = new TipoEntregaPersonalizadaModel();
            envio.id  = json["id"];
            envio.descripcion = json["nombre"];
            envio.estado = json["activo"];
            envios.add(envio);
        }
          return envios;
    }    

}