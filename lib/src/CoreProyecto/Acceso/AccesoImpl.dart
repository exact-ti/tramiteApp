import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface{

  LogeoInterface logeo;

    AccesoImpl(LogeoInterface logeo){
          this.logeo = logeo;
    }

  @override
  void logear(String mensaje) {

      logeo.logeo(mensaje);

  }
  
}