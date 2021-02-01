
class Indicador {
  String nombre;
  int cantidad;
  int id;

  List<Indicador> fromJsonToIndicador(List<dynamic> jsons) {
    List<Indicador> listindicador = new List();
    for(Map<String, dynamic> json in jsons){
        Indicador  indicador = new Indicador();
        indicador.id  = json["id"];
        indicador.nombre  = json["nombre"];
        indicador.cantidad  = json["cantidad"];
        listindicador.add(indicador);
    }
    return listindicador;
  }

    List<Indicador> listHomeDashboard(List<dynamic> jsons) {
    List<Indicador> listindicador = new List();
    for(Map<String, dynamic> json in jsons){
        Indicador  indicador = new Indicador();
        indicador.nombre  = json["nombre"];
        indicador.cantidad  = json["cantidad"];
        listindicador.add(indicador);
    }
    return listindicador;
  }
}
