import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

class LogeoFusionAuth implements LogeoInterface{


  @override
  void logeo(String mensaje) {

            print("Ingreso el Servicio LogeoFusionAuth y el mensaje es el siguiente : "+mensaje);

  }
  
}