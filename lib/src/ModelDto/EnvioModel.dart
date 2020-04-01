class EnvioModel {
  int id;
  int remitenteId;
  int destinatarioId;
  String codigoPaquete;
  String codigoUbicacion;
  String observacion;
  bool estado;


      EnvioModel({
        this.id,
        this.remitenteId,
        this.destinatarioId,
        this.codigoUbicacion='',
        this.codigoPaquete='',
        this.observacion='',
        this.estado = true
    });


    List<EnvioModel> fromJsonValidar(List< dynamic> jsons){
       List<EnvioModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioModel  envio = new EnvioModel();
            envio.id  = json["id"];
            envio.codigoPaquete = json["paqueteId"];
            envios.add(envio);
        }
          return envios;
    }    


  EnvioModel fromOneJson(dynamic json){
           EnvioModel  envio = new EnvioModel();
            envio.id  = json["id"];
            envio.codigoPaquete = json["codigoPaquete"];
          return envio;
    }   

    Map<String, dynamic> toJson() => {
        "id"                    :id,
        "remitenteId"         : remitenteId,
        "destinatarioId"     : destinatarioId,
        "codigoPaquete"   : codigoPaquete,
         "codigoUbicacion"     : codigoUbicacion,
        "observacion"   : observacion,       
    };

}