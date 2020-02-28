import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

class LogeoFusionAuth implements LogeoInterface{


  @override
  String logeo(String username , String password){

            print("Ingreso el Servicio LogeoFusionAuth y el mensaje es el siguiente : "+username+"password:"+username);

            return username;

  }
  
}