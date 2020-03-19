import 'dart:convert';

//Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  int id;
  String nombre;
  String link;
  int orden;

    Menu({
        this.id,
        this.nombre = '',
        this.link = '',
        this.orden = 0,
    });

    List<Menu> fromJson(List< dynamic> jsons){
       List<Menu> menus= new List();
        
        for(Map<String, dynamic> json in jsons){
           Menu men = new Menu();
            men.id  = json["id"];
            men.nombre     = json["nombre"];
            men.link      = json["link"];
            men.orden = json["orden"];
            menus.add(men);
        }
          return menus;
    }

        List<Menu> fromPreferencs(List< dynamic> jsons){
       List<Menu> menus= new List();
        
        for(Map<String, dynamic> json in jsons){
           Menu men = new Menu();
            men.id  = json["id"];
            men.nombre     = json["titulo"];
            men.link      = json["valor"];
            men.orden = json["disponible"];
            menus.add(men);
        }
          return menus;
    }
         



    Map<String, dynamic> toJson() => {
        "id"         : id,
        "titulo"     : nombre,
        "valor"      : link,
        "disponible" : orden
    };




}