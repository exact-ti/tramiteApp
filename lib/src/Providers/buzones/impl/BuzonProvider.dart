import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Buzon.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

class BuzonProvider implements IBuzonProvider {
  
  Requester req = Requester();

  BuzonModel buzonmodel = new BuzonModel();

  @override
  Future<List<BuzonModel>> listarBuzonesDelUsuarioAutenticado() async {
    Response resp = await req.get('/servicio-tramite/usuarios/buzones');
    List<dynamic>  buzones = resp.data;
    List<BuzonModel> listbuzon = buzonmodel.fromJson(buzones);
    return listbuzon;
  }

  @override
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    //ids.asMap();
    String buzonesId = "";
    for (var i = 0; i < ids.length; i++) {
      if (i == 0) buzonesId += ids[i].toString();
      else buzonesId += "," + ids[i].toString();
    }
    Response resp = await req.get('/servicio-tramite/buzones?ids=$buzonesId');
    List<dynamic> buzones = resp.data;
    List<BuzonModel> listbuzon = buzonmodel.fromJsonValidos(buzones);
    return listbuzon;
  }

}