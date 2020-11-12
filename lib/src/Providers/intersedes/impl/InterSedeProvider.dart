import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';
import '../IInterSedeProvider.dart';

class InterSedeProvider implements IInterSedeProvider {
  Requester req = Requester();
  EnvioInterSedeModel sedeModel = new EnvioInterSedeModel();
  EnvioModel envioModel = new EnvioModel();

  @override
  Future<List<EnvioInterSedeModel>> listarEnvioByUsuario() async {
    int utdId = obtenerUTDid();
    Response resp =
        await req.get('/servicio-tramite/utds/$utdId/utdsparaentrega');
    return sedeModel.fromJsonValidar(resp.data);
  }

  @override
  Future<List<EnvioInterSedeModel>> listarRecepcionByUsuario() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get(
        '/servicio-tramite/utds/$utdId/tiposentregas/$entregaValijaId/entregas/recepcion');
    return sedeModel.fromJsonValidarRecepcion(resp.data);
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo) async {
    int utdId = obtenerUTDid();
    Response resp = await req.get(
        '/servicio-tramite/utds/$utdId/tipospaquetes/$valijaId/paquetes/$codigo/envios');
    if (resp.data == "" || resp.data == null) return null;
    return envioModel.fromJsonValidar(resp.data);
  }

  @override
  Future<EnvioModel> validarCodigoProvider(
      String codigo, String codigobandeja) async {
    Response resp = await req.get(
        '/servicio-tramite/tipospaquetes/valijas/$codigobandeja/paquetes/$codigo');
    if (resp.data == "") return null;
    return envioModel.fromOneJson(resp.data);
  }

  @override
  Future<dynamic> listarEnviosValidadosInterSede(
      List<EnvioModel> enviosvalidados, String codigo) async {
    int utdId = obtenerUTDid();
    List<int> ids = enviosvalidados.map((envio) => envio.id).toList();
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/valijas/$codigo/tiposentregas/$entregaValijaId/entregas',
        listaIds,
        null);
    return resp.data;
  }

  @override
  Future<bool> iniciarEntregaIntersede(int utdDestino) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/utdsdestinos/$utdDestino/iniciar',
        null,
        null);
    return resp.data ? true : false;
  }

  @override
  Future<List<EnvioModel>> listarRecepcionByCodigo(String codigo) async {
    int utdId = obtenerUTDid();
    Response resp = await req
        .get('/servicio-tramite/utds/$utdId/entregas/$codigo/recepcion');
    if (resp.data == "") return [];
    return envioModel.fromJsonValidar(resp.data);
  }

  @override
  Future<dynamic> registrarRecojoIntersedeProvider(
      String codigo, String codigopaquete) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/paquetes/$codigopaquete/custodia',
        null,
        null);
    return resp.data;
  }
}
