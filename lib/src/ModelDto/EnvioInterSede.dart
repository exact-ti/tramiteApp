class EnvioInterSedeModel {
  int utdId;
  int numdocumentos;
  int numvalijas;
  String destino;
  int estadoEnvio;
  String codigo;

      EnvioInterSedeModel({
        this.utdId,
        this.numdocumentos,
        this.numvalijas,
        this.destino='',
    });


    List<EnvioInterSedeModel> fromJsonValidar(List< dynamic> jsons){
       List<EnvioInterSedeModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioInterSedeModel  envio = new EnvioInterSedeModel();
            envio.utdId  = json["utdId"];
            envio.numdocumentos  = json["cantidadEnvios"];
            envio.numvalijas = json["cantidadValijas"];
            envio.estadoEnvio=json["estadoEnvio"];
            envio.destino = json["utd"];
            envios.add(envio);
        }
          return envios;
    }   

    List<EnvioInterSedeModel> fromJsonValidarRecepcion(List< dynamic> jsons){
       List<EnvioInterSedeModel> envios= new List();
        for(Map<String, dynamic> json in jsons){
           EnvioInterSedeModel  envio = new EnvioInterSedeModel();
            envio.utdId  = json["utdId"];
            envio.numdocumentos  = json["cantidadEnvios"];
            envio.codigo = json["codigo"];
            envio.estadoEnvio=json["estadoEnvio"];
            envio.destino = json["utd"];
            envios.add(envio);
        }
          return envios;
    }     


  EnvioInterSedeModel fromOneJson(dynamic json){
           EnvioInterSedeModel  envio = new EnvioInterSedeModel();
            envio.utdId  = json["id"];
          return envio;
    }   


}