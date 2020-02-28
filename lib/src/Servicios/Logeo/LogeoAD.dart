import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

class LogeoAD implements LogeoInterface{

  @override
  String logeo(String username , String password) {
            print("Ingreso el Servicio LogeoAD y el mensaje es el siguiente : "+username);
            return username;
  }
  
}