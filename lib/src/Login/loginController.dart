
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoFusionAuth.dart';

class LoginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoFusionAuth());
    
    validarlogin(BuildContext context, String username , String password) {
       
        accesoInterface.login( username , password).then((data){
          print(data);
          Navigator.of(context).pushNamed('principal-admin');
        });
    }

}
