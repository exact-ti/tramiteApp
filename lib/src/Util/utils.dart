import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';
  EnvioController envioController = new EnvioController();

void mostrarAlerta(BuildContext context, String mensaje,String titulo) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$titulo'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Drawer crearMenu(BuildContext context) {
  return Drawer(
    child: ListView(padding: EdgeInsets.zero, 
    children: milistview(context)),
  );
}


Widget respuesta(String contenido){
  return Text(contenido,style:TextStyle(color: Colors.red,fontSize: 15));
}

Widget errorsobre(String rest, int numero){

  int minvalor = 5;



  if(rest.length==0 && numero ==0){
       return Container(); 
  }

  if(rest.length==0 && numero !=0){
      return respuesta("Es necesario ingresar el código del sobre");
  }

  if(rest.length>0 && rest.length<minvalor){
      return respuesta("La longitud mínima es de $minvalor caracteres");

  }


return FutureBuilder(
          future: envioController.validarexistencia(rest),
          builder: (BuildContext context,
              AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
             final validador = snapshot.data;
             if(!validador){
             return respuesta("El código no existe");
             }else{
              return Container();
             }
            } else {
              return Container();
            }
          });


  //return Container();


}


Widget errorbandeja(String rest, int numero){

  int minvalor = 5;

  if(rest.length==0 && numero ==0){
       return Container(); 
  }

  if(rest.length>0 && rest.length<minvalor){
      return respuesta("La longitud mínima es de $minvalor caracteres");

  }
/*
  if(envioController.validarexistenciabandeja(rest) && rest.length>0 ){
      return respuesta("El código no existe");
  }*/ 


  return Container();


}



List<Widget> milistview(BuildContext context) {
  List<Widget> list = new List<Widget>();
  final _prefs = new PreferenciasUsuario();
  Menu menuu = new Menu();
  List<dynamic> menus = json.decode(_prefs.menus);
  List<Menu> listmenu = menuu.fromPreferencs(menus);
  list.add(DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/original.jpg'),
                      fit: BoxFit.cover)),
            ));
  for (Menu men in listmenu) {
    list.add(ListTile(
        leading: Icon(Icons.pages, color: Colors.blue),
        title: Text(men.nombre),
        onTap: () => Navigator.pushReplacementNamed(context, men.link)));
  }
  return list;
}
