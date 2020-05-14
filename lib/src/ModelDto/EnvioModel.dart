
class EnvioModel {
  int id;
  int remitenteId;
  int destinatarioId;
  String codigoPaquete;
  String codigoUbicacion;
  String observacion;
  String usuario;
  String destinatario;
  String remitente;
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


    List<EnvioModel> fromJsonValidarRecepcion(List< dynamic> jsons){
       List<EnvioModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioModel  envio = new EnvioModel();
            envio.usuario = json["usuario"];
            envio.codigoPaquete = json["paqueteId"];
            envio.observacion = json["observacion"];
            envios.add(envio);
        }
          return envios;
    }  

    List<EnvioModel> fromEnviadosActivos(List< dynamic> jsons){
       List<EnvioModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioModel  envio = new EnvioModel();
            envio.remitente = json["remitente"];
            envio.destinatario = json["destinatario"];
            envio.codigoPaquete = json["paqueteId"];
            envio.observacion= json["estado"];
            envio.id =json["id"];
            envios.add(envio);
        }
          return envios;
    }  


    List<EnvioModel> fromJsonConsultaEnvio(List< dynamic> jsons){
       List<EnvioModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioModel  envio = new EnvioModel();
            envio.codigoPaquete = json["paqueteId"];
            envio.destinatario = json["destinatario"];
            envio.remitente = json["remitente"];
            envio.codigoUbicacion = json["ubicacion"];
            envios.add(envio);
        }
          return envios;
    }  


  EnvioModel  fromOneJson(dynamic json){
           EnvioModel  envio = new EnvioModel();
            envio.id  = json["id"];
            envio.codigoPaquete = json["paqueteId"];
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