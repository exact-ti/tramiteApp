import 'package:tramiteapp/src/ServiciosTest/Logeo/LogeoInterface.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:async';

class LogeoAD implements LogeoInterface{

  List<dynamic> options = [];

  String token = "";  

  Future<String> cargarData(String username , String password) async {
    
          final resp = await rootBundle.loadString('assets/menu_opts.json');
  
          //var myThing = (json.decode(resp) as List).map((e) => new MyClass.fromJson(e)).toList();

          List<dynamic> dataMap = json.decode(resp);

          for (var data in dataMap) {
              if(data['usuario']==username && data['password']==password){
                  token=data['jwt'];
              }
          }


          //print(dataMap['nombreApp']);
          //options = dataMap['rutas'];

          return token;
   }

  @override
  Future<String> logeo(String username , String password)   {

           var val =  cargarData( username ,  password);
      
            //print("Ingreso el Servicio LogeoAD y el mensaje es el siguiente : "+ val);

            return val;
  }
  
}