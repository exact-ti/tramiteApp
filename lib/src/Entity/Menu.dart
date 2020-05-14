import 'dart:convert';

import 'dart:convert' as prefix0;

//Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  int id;
  String nombre;
  String link;
  int orden;
  bool home;
  String icono;

    Menu({
        this.id,
        this.nombre = '',
        this.link = '',
        this.orden = 0,
        this.home =true
    });

    List<Menu> fromJson(List< dynamic> jsons){
       List<Menu> menus= new List();
        
        for(Map<String, dynamic> json in jsons){
           Menu men = new Menu();
            men.id  = json["id"];
            men.nombre  = json["nombre"];
            men.link  = json["link"];
            men.orden = json["orden"];
            men.home = json["home"];
            men.icono = json["icono"];
            menus.add(men);
        }
          return menus;
    }

        List<Menu> fromPreferencs(List< dynamic> jsons){
       List<Menu> menus= new List();
        
        for(Map<String, dynamic> json in jsons){
           Menu men = new Menu();
            men.id  = json["id"];
            men.nombre= json["nombre"];
            men.link = json["link"];
            men.orden = json["orden"];
            men.home = json["home"];
            men.icono = json["icono"];
            menus.add(men);
        }
          return menus;
    }
         



    Map<String, dynamic> toJson() => {
        "id"         : id,
        "nombre"     : nombre,
        "link"      : link,
        "orden"       : orden,
        "home"       : home, 
        "icono"       : icono,               
    };

}