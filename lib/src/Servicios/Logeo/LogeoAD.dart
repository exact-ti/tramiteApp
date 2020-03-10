import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

class LogeoAD implements LogeoInterface{

  @override
  Future<Map<String, dynamic>> logeo(String username , String password) {
            print("Ingreso el Servicio LogeoAD y el mensaje es el siguiente : "+username);
            return null;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) {
    // TODO: implement login
    return null;
  }
  
}