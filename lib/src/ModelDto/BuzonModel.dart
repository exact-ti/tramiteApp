import 'package:tramiteapp/src/ModelDto/TipoBuzonModel.dart';
import 'dart:convert';

String buzonModelToJson(BuzonModel data) => json.encode(data.toJson() );


class BuzonModel {
  int id;
  String nombre;
  TipoBuzonModel tipoBuzon;

      BuzonModel({
        this.id,
        this.nombre = ''
    });

    List<BuzonModel> fromJson(List< dynamic> jsons){
       List<BuzonModel> buzones= new List();
        
        for(Map<String, dynamic> json in jsons){
           BuzonModel men = new BuzonModel();
           TipoBuzonModel tipobuzons = new TipoBuzonModel();
            men.id  = json["id"];
            men.nombre  = json["nombre"];
            Map<String, dynamic> tipobuzon = json["tipoBuzon"];
            tipobuzons.id =tipobuzon["id"];
            tipobuzons.nombre =tipobuzon['nombre'];
            men.tipoBuzon=tipobuzons;
            buzones.add(men);
        }
          return buzones;
    }

    BuzonModel fromPreferencs(var json){
       BuzonModel buzones= new BuzonModel();
            buzones.id  = json["id"];
            buzones.nombre  = json["nombre"];
          return buzones;
    }
         

    Map<String, dynamic> toJson() => {
        "id"         : id,
        "nombre"     : nombre,
        "tipoBuzon"      : tipoBuzon,
    };

}