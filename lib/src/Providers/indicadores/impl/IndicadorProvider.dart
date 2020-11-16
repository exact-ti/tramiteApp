import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/Indicador.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import '../IIndicadorProvider.dart';

class IndicadorProvider implements IIndicadorProvider {
  Requester req = Requester();
  Indicador indicador = new Indicador();
  String serviceBack = "/servicio-tramite/";

  @override
  Future<List<Indicador>> listIndicador() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get(serviceBack + 'indicadores/enviosenutd?utdId=$utdId');
    dynamic listData = resp.data;
    return indicador.listHomeDashboard(listData["data"]);
  }
}
