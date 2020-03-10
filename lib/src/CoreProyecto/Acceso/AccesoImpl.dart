
import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';

import 'AccesoInterface.dart';

class AccesoImpl implements AccesoInterface {
  LogeoInterface logeo;

  AccesoImpl(LogeoInterface logeo) {
    this.logeo = logeo;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async{
        Map<String, dynamic> interfaceLogear = await logeo.login(username, password);
        return interfaceLogear;
  
  }
}
