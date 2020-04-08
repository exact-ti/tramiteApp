

class PaqueteExternoBuzonModel {

  String id;  
  String nombre;
  int idBuzon;

  List<PaqueteExternoBuzonModel> fromJson(List< dynamic> jsons){
       List<PaqueteExternoBuzonModel> registrosProValidar = new List();
        for(Map<String, dynamic> json in jsons){
          PaqueteExternoBuzonModel paqueteBuzon = new PaqueteExternoBuzonModel();          
          
            paqueteBuzon.id  = json["id"];            
            paqueteBuzon.nombre = json["nombre"];    
            paqueteBuzon.idBuzon = json["id_buzon"];
            registrosProValidar.add(paqueteBuzon);
        }
          return registrosProValidar;
    }

}