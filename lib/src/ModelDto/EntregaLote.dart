import 'dart:collection';

import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';

class EntregaLoteModel {
  
  int utdId;
  String udtNombre;
  int cantLotes;
  EstadoEnvio estadoEnvio;

  EntregaLoteModel({
      this.utdId,
      this.udtNombre,
      this.cantLotes
  });


  List<EntregaLoteModel> fromJsonValidar(List< dynamic> jsons){
      List<EntregaLoteModel> entregas = new List();
      for(Map<String, dynamic> json in jsons){
          EntregaLoteModel  entrega = new EntregaLoteModel();
          EstadoEnvio estado = new EstadoEnvio();
            Map<String, dynamic> estadoMap = new HashMap();
          entrega.utdId  = json["utdId"];
          entrega.udtNombre  = json["udtNombre"];
          entrega.cantLotes = json["cantLotes"];
          estadoMap =json["estado"];
          estado.id=estadoMap["id"];
          estado.nombre=estadoMap["nombre"];
          entrega.estadoEnvio=estado;
          entregas.add(entrega);
      }
        return entregas;
  }     


}