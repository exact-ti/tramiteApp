import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';

class EnvioInterSedeModel {
  int utdId;
  int numdocumentos;
  int numvalijas;
  String destino;
  String codigo;
  EstadoEnvio estadoEnvio;

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
            EstadoEnvio estado = new EstadoEnvio();
              Map<String, dynamic> estadoMap = new HashMap();
            envio.utdId  = json["utdId"];
            envio.numdocumentos  = json["cantidadEnvios"];
            envio.numvalijas = json["cantidadValijas"];
            envio.destino = json["utd"];
            estadoMap =json["estado"];
            estado.id=estadoMap["id"];
            estado.nombre=estadoMap["nombre"];
            envio.estadoEnvio=estado;
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