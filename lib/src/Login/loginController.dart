
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoAD.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoFusionAuth.dart';

class loginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoAD());





    void enviarmensaje(String mensaje){

        print("Ingreso el logincontroller y el mensaje es el siguiente : "+mensaje);

        accesoInterface.logear(mensaje);
    }

}