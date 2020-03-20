
import 'dart:convert';
String configuracionModelModelToJson(ConfiguracionModel data) => json.encode(data.toJson() );

class ConfiguracionModel {
  int id;
  String nombre;
  String valor;

      ConfiguracionModel({
        this.id,
        this.nombre = '',
        this.valor=''
    });

    List<ConfiguracionModel> fromJson(List< dynamic> jsons){
       List<ConfiguracionModel> configuraciones= new List();
        for(Map<String, dynamic> json in jsons){
           ConfiguracionModel men = new ConfiguracionModel();
            men.id  = json["id"];
            men.nombre  = json["clave"];
            men.valor = json["valor"];
            configuraciones.add(men);
        }
          return configuraciones;
    }

    List<ConfiguracionModel> fromPreferencs(List< dynamic> jsons){
       List<ConfiguracionModel> configuraciones= new List();
        for(Map<String, dynamic> json in jsons){
           ConfiguracionModel men = new ConfiguracionModel();
            men.id  = json["id"];
            men.nombre  = json["nombre"];
            men.valor = json["valor"];
            configuraciones.add(men);
        }
          return configuraciones;
    }
         

    Map<String, dynamic> toJson() => {
        "id"         : id,
        "nombre"     : nombre,
        "valor"      : valor,
    };


}