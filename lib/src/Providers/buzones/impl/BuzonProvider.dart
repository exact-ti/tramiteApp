import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

class BuzonProvider implements IBuzonProvider {
  
  Requester req = Requester();

  BuzonModel buzonmodel = new BuzonModel();

  @override
  Future<List<BuzonModel>> listarBuzonesDelUsuarioAutenticado() async {
    Response resp = await req.get('/servicio-tramite/usuarios/buzones');
    return  buzonmodel.fromJson(resp.data);
  }

  @override
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    String buzonesId = "";
    for (var i = 0; i < ids.length; i++) {
      if (i == 0) buzonesId += ids[i].toString();
      else buzonesId += "," + ids[i].toString();
    }
    Response resp = await req.get('/servicio-tramite/buzones?ids=$buzonesId');
    return buzonmodel.fromJsonValidos(resp.data);
  }
}