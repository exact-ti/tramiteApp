import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

class LogeoAD implements LogeoInterface{


  @override
  void logeo(String mensaje) {

            print("Ingreso el Servicio LogeoAD y el mensaje es el siguiente : "+mensaje);

  }
  
}