
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Acceso/AccesoInterface.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoFusionAuth.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class LoginController {

    AccesoInterface accesoInterface = new AccesoImpl(new LogeoFusionAuth());
    
    validarlogin(BuildContext context, String username , String password) {
        print("adsa");
        accesoInterface.login( username , password).then((data){
          print(data);
          if(data==null){
          mostrarAlerta(context, 'El usuario y contraseña son incorrectos');
          }else{
          Navigator.of(context).pushNamed('/principal-admin');
          }
        });
    }

}
