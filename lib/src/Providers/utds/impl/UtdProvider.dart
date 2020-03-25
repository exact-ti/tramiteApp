import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Buzon.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

import '../IUtdProvider.dart';

class UtdProvider implements IUtdProvider {
  
  Requester req = Requester();

  UtdModel utdmodel = new UtdModel();

  @override
  Future<List<UtdModel>> listarUtdsDelUsuarioAutenticado() async{
    Response resp = await req.get('/servicio-utd/usuarios/utds');
    List<dynamic>  buzones = resp.data;
    List<UtdModel> listbuzon = utdmodel.fromJson(buzones);
    return listbuzon;
  }

}