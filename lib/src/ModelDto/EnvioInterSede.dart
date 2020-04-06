class EnvioInterSedeModel {
  int id;
  int numdocumentos;
  int numvalijas;
  String destino;
  int codigoEnvio;

      EnvioInterSedeModel({
        this.id,
        this.numdocumentos,
        this.numvalijas,
        this.codigoEnvio,
        this.destino='',
    });


    List<EnvioInterSedeModel> fromJsonValidar(List< dynamic> jsons){
       List<EnvioInterSedeModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioInterSedeModel  envio = new EnvioInterSedeModel();
            envio.id  = json["id"];
            envio.codigoEnvio = json["paqueteId"];
            envio.numdocumentos  = json["id"];
            envio.numvalijas = json["paqueteId"];
            envio.destino = json["paqueteId"];
            envios.add(envio);
        }
          return envios;
    }    


  EnvioInterSedeModel fromOneJson(dynamic json){
           EnvioInterSedeModel  envio = new EnvioInterSedeModel();
            envio.id  = json["id"];
            envio.codigoEnvio = json["paqueteId"];
          return envio;
    }   


}