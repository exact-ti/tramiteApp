import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/lotes/IEntregaLoteProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class EntregaLoteProvider implements IEntregaLoteProvider{
  UtdModel utdModel = new UtdModel();
  Requester req = Requester();
  EntregaLoteModel entregaLoteModel = new EntregaLoteModel();
  
  @override
  Future<List<EntregaLoteModel>> listarLotesActivos() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/lotesactivos');
    return entregaLoteModel.fromJsonValidar(resp.data);
  }

    @override
  Future<bool> iniciarEntregaLote(int utdDestino) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/utdsdestinos/$utdDestino/lotes/inicio',
        null,
        null);
    return resp.data?true:false;
  }

  @override
  Future<List<EntregaLoteModel>> listarLotesPorRecibir() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/lotes/recepcion');
    return entregaLoteModel.fromJsonRecepcion(resp.data);
  }

}