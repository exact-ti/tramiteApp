import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IRutaProvider.dart';

class RutaProvider implements IRutaProvider {
  Requester req = Requester();
  RutaModel rutaModel = new RutaModel();
  DetalleRutaModel detallerutaModel = new DetalleRutaModel();

  @override
  Future<List<RutaModel>> listarMiRuta(int recorridoId) async {
    Response resp =
        await req.get('/servicio-tramite/recorridos/$recorridoId/areas');
    return rutaModel.fromJson(resp.data);
  }

  @override
  Future<bool> iniciarRecorrido(int recorridoId) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/inicio', null, null);
    return resp.data;
  }

  @override
  Future<bool> terminarRecorrido(int recorridoId) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/termino', null, null);
    return resp.data;
  }

  @override
  Future<List<DetalleRutaModel>> listarDetalleMiRutaEntrega(
      String areaId, int recorridoId) async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/$recorridoId/areas/$areaId/detalle/entrega');
    dynamic respdata = resp.data;
    return detallerutaModel.detalleRutafromJson(respdata["data"]);
  }

  @override
  Future<List<DetalleRutaModel>> listarDetalleMiRutaRecojo(
      String areaId, int recorridoId) async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/$recorridoId/areas/$areaId/detalle/recojo');
    dynamic respdata = resp.data;
    return detallerutaModel.detalleRutafromJson(respdata["data"]);
  }

  @override
  Future enviarNotificacionToAusencia(String paqueteId) async {
    Response resp = await req.post(
        '/servicio-tramite/envios/notificaciones/creadopendiente', null, {
      "paqueteId": paqueteId,
    });
    return resp.data;
  }
}
