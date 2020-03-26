//import 'dart:convert';

//Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

//String usuarioFrecuenteToJson(UsuarioFrecuente data) => json.encode(data);

class UsuarioFrecuente {
  
  int id;
  String nombre;
  String sede;
  String area;

    UsuarioFrecuente({
        this.id,
        this.nombre = '',
        this.sede = '',
        this.area = '',
    });

    List<UsuarioFrecuente> fromJson(List< dynamic> jsons){
       List<UsuarioFrecuente> usuarios= new List();
        
        for(Map<String, dynamic> json in jsons){
           UsuarioFrecuente men = new UsuarioFrecuente();
            men.id  = json["id"];
            men.nombre = json["nombre"];
            men.sede = json["sede"];
            men.area = json["area"];
            usuarios.add(men);
        }
          return usuarios;
    }

}