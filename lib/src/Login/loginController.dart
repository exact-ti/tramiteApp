
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoAD.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoFusionAuth.dart';

class LoginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoAD());

    String enviarmensaje(String username , String password){

        print("Ingreso el username y el password es el siguiente : "+username+" password "+password);

        String interfaceLogear = accesoInterface.logear( username , password);

        return interfaceLogear;
    }

}





int devolver(){
  return 20;
}