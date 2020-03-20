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
    Response resp = await req.get('/servicio-buzon/buzones');
    List<dynamic>  buzones = resp.data;
    List<BuzonModel> listbuzon = buzonmodel.fromJson(buzones);
    return listbuzon;
  }

}