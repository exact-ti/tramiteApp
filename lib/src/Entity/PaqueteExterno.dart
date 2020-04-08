

class PaqueteExterno {

  int id;
  String paqueteId;
  String destinatarioId;
  String tipoPaquete;

  Map<String, dynamic> toJson() => {
    "paqueteId"       : paqueteId,
    "destinatarioId"  : destinatarioId
  };

  List<PaqueteExterno> fromJsonCreados(List< dynamic> jsons){
       List<PaqueteExterno> creados = new List();
        for(Map<String, dynamic> json in jsons){
          PaqueteExterno p = new PaqueteExterno();          
          
            p.id  = json["id"];            
            p.paqueteId = json["codigoPaquete"];    
            p.tipoPaquete = json["tipoPaquete"];

            creados.add(p);
        }
          return creados;
    }

}