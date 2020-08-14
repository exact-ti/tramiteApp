import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

import '../IUtdProvider.dart';

class UtdProvider implements IUtdProvider {
  
  Requester req = Requester();

  UtdModel utdmodel = new UtdModel();

  @override
  Future<List<UtdModel>> listarUtdsDelUsuarioAutenticado() async{
    Response resp = await req.get('/servicio-tramite/usuarios/utds');
    List<dynamic>  buzones = resp.data;
    List<UtdModel> listbuzon = utdmodel.fromJson(buzones);
    return listbuzon;
  }

}