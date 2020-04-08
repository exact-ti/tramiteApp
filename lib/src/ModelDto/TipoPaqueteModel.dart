
class TipoPaqueteModel {
  
  int id;
  String nombre;
  bool interno;

  List<TipoPaqueteModel> fromJson(List< dynamic> jsons){
       List<TipoPaqueteModel> tipoPaquetes= new List();
        for(Map<String, dynamic> json in jsons){
          TipoPaqueteModel tipoPaquete = new TipoPaqueteModel();
          
          tipoPaquete.id = json["id"];
          tipoPaquete.nombre = json["nombre"];
          tipoPaquete.interno = json["interno"];

          tipoPaquetes.add(tipoPaquete);
        }
          return tipoPaquetes;
    }
}