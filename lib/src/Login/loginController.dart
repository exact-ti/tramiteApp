
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoFusionAuth.dart';

class LoginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoFusionAuth());
    
    Future<Map<String, dynamic>> validarlogin(String username , String password) async{
        print("Ingreso el username y el password es el siguiente : "+username+" password "+password);
        Map<String, dynamic> interfaceLogear = await accesoInterface.login( username , password);
        return interfaceLogear;
    }

}
