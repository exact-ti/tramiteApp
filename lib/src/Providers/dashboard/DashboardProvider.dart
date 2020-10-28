import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'IDashboardProvider.dart';


class DashboardProvider implements IDashboardProvider {
  
  Requester req = Requester();

  @override
  Future listarIndicadores() async{
    int buzonId = obtenerBuzonid();
    Response resp = await req.get('/servicio-tramite/buzones/$buzonId/indicadores');
    dynamic respdata = resp.data;
    return respdata["data"];
  }

}