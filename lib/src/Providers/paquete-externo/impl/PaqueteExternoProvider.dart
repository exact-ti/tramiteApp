import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/IPaqueteExternoProvider.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class PaqueteExternoProvider implements IPaqueteExternoProvider {

  Requester req = Requester();
  TipoPaqueteModel tipoPaqueteModel = new TipoPaqueteModel();
  PaqueteExterno paquete = new PaqueteExterno();

  @override
  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno) async{
    bool inactivos = false;
    Response resp = await req.get('/servicio-tramite/tipospaquetes?interno=$interno&mostrarInactivos=$inactivos');
    return tipoPaqueteModel.fromJson(resp.data);
  }

  @override
  Future<dynamic> importarPaquetesExternos(List<PaqueteExterno> paqueteExterno, TipoPaqueteModel tipoPaquete) async {
    int utdId = obtenerUTDid();
    final formData = json.encode(paqueteExterno);
    Response resp = await req.post('/servicio-tramite/utds/$utdId/tipospaquetes/${tipoPaquete.id}/importacion',formData,null);
    return resp.data;
  }

  @override
  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/envios?interno=0&estadoId=1');
    return paquete.fromJsonCreados(resp.data);
  }

  @override
  Future<dynamic> custodiarPaquete(String paqueteExterno) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post('/servicio-tramite/utds/$utdId/paquetes/$paqueteExterno/custodia',null,null);
    return resp.data;
  }

  

}