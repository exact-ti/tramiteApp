import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import '../IRecepcionProvider.dart';

class RecepcionProvider implements IRecepcionProvider {
  
  Requester req = Requester();

  EnvioModel envioModel = new EnvioModel();

  @override
  Future recepcionJumboProvider(String codigo, int utdId) async {
    Response resp = await req
        .get('/servicio-tramite/utds/$utdId/lotes/$codigo/recepcion');
    return resp.data;
  }

  @override
  Future<List<EnvioModel>> recepcionValijaProvider(String codigo) async {
    Response resp = await req.get('/servicio-tramite/areas/$codigo/envios');
    if (resp.data == "") return null;
    return envioModel.fromJsonValidar(resp.data);
  }

  @override
  Future<bool> registrarJumboProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/entrega',
        null,
        null);
    return resp.data;
  }

  @override
  Future<dynamic> recibirJumboProvider( String codigoLote, String codigopaquete) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post('/servicio-tramite/utds/$utdId/entregas/$codigopaquete/validacion',null,null);
    return resp.data;
  }

  @override
  Future<bool> registrarValijaProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/recojo',
        null,
        null);
    return resp.data;
  }

  @override
  Future<List<EnvioModel>> listarenvios() async {
    Response resp = await req.get('/servicio-tramite/recorridos/areas/envios/paraentrega');
    if (resp.data == "") return null;
    return envioModel.fromJsonValidar(resp.data);
  }

  @override
  Future<bool> registrarEnvioProvider(String codigopaquete) async {
    Response resp = await req.post('/servicio-tramite/recorridos/areas/paquetes/$codigopaquete/entrega',null,null);
    return resp.data;
  }

  @override
  Future<List<EnvioModel>> listarenviosPrincipal() async {
    int buzonId = obtenerBuzonid();
    Response resp = await req.get('/servicio-tramite/buzones/$buzonId/envios/confirmacion');
    if (resp.data == "") return null;
    return envioModel.fromJsonValidarRecepcion(resp.data);
  }

  @override
  Future<bool> registrarListaEnvioPrincipalProvider(List<String> codigospaquetes) async {
    int buzonId = obtenerBuzonid();
    var listaIds = json.encode(codigospaquetes);
    Response resp = await req.post('/servicio-tramite/buzones/$buzonId/envios/confirmacion', listaIds, null);
    return resp.data;
  }
}
