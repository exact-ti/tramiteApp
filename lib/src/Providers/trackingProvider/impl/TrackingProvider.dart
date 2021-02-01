import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../ITrackingProvider.dart';

class TrackingProvider implements ITrackingProvider {

  Requester req = Requester();
  TrackingModel trackingModel = new TrackingModel();

  @override
  Future<TrackingModel> mostrarTracking(int codigo) async {
    Response resp = await req.get('/servicio-tramite/envios/$codigo/detalle');
    Response resp2 = await req.get('/servicio-tramite/envios/$codigo/seguimientos');
    return  trackingModel.fromOneJsonTracking(resp.data, resp2.data);
  }

}
