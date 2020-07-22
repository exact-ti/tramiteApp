import 'dart:convert';

String utdModelToJson(UtdModel data) => json.encode(data.toJson() );


class UtdModel {
  int id;
  String nombre;
  bool principal;

      UtdModel({
        this.id,
        this.nombre = '',
        this.principal=true
    });

    List<UtdModel> fromJson(List< dynamic> jsons){
       List<UtdModel> utds= new List();
        
        for(Map<String, dynamic> json in jsons){
           UtdModel men = new UtdModel();
            men.id  = json["id"];
            men.nombre  = json["nombre"];
            men.principal  = json["principal"];
            utds.add(men);
        }
          return utds;
    }

    UtdModel fromPreferencs(var json){
       UtdModel buzones= new UtdModel();
            buzones.id  = json["id"];
            buzones.nombre  = json["nombre"];
            buzones.principal = json["principal"];
          return buzones;
    }

      List<UtdModel> listfromPreferencs(List< dynamic> jsons){
       List<UtdModel> utds= new List();
        for(Map<String, dynamic> json in jsons){
           UtdModel men = new UtdModel();
            men.id  = json["id"];
            men.nombre= json["nombre"];
            men.principal = json["principal"];
            utds.add(men);
        }
          return utds;
    }
    
         

    Map<String, dynamic> toJson() => {
        "id"         : id,
        "nombre"     : nombre,
        "principal"  : principal,
    };

}