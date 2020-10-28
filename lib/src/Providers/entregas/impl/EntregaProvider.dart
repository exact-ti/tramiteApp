import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';
import '../IEntregaProvider.dart';

class EntregaProvider implements IEntregaProvider {
  Requester req = Requester();
  EntregaModel entregaModel = new EntregaModel();
  EnvioModel envioModel = new EnvioModel();
  RecorridoModel recorridoModel = new RecorridoModel();

  @override
  Future<List<EntregaModel>> listarEntregaporUsuario() async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/recorridos');
    return entregaModel.fromJson(resp.data);
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoUsuario() async {
    int utdId = obtenerUTDid();
    Response resp = await req
        .get('/servicio-tramite/utds/$utdId/turnos/usuarioautenticado');
    return recorridoModel.fromJson(resp.data);
  }

  @override
  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId) async {
    Response resp = await req
        .get('/servicio-tramite/turnos/$recorridoId/envios/paraentrega');
    return envioModel.fromJsonValidar(resp.data);
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoporNombre(String nombre) async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/utds/$utdId/turnos?nombre=$nombre');
    return recorridoModel.fromJson(resp.data);
  }

  @override
  Future<int> listarEnviosValidados(
      List<EnvioModel> enviosvalidados, int id) async {
    List<int> ids = enviosvalidados.map((envio) => envio.id).toList();
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/turnos/$id/recorridos', listaIds, null);
    return resp.data;
  }

  @override
  Future<EnvioModel> validarCodigoProvider(String codigo, int id) async {
    Response resp = await req.get(
        '/servicio-tramite/turnos/$id/envios/paraagregaralrecorrido?paqueteId=$codigo');
    if (resp.data == "") return null;
    EnvioModel envioMode = envioModel.fromOneJson(resp.data);
    return envioMode;
  }

  @override
  Future<dynamic> listarTurnosByCodigoLote(String codigo) async {
    int utdId = obtenerUTDid();
    Response resp = await req.get('/servicio-tramite/tipospaquetes/lotes/$codigo/turnos?utdId=$utdId');
    return resp.data;
  }

  @override
  Future<EnvioModel> listarValijaByCodigoLote(String codigo) async {
      Response resp = await req.get(
          '/servicio-tramite/tiposentregas/$entregaValijaId/valijas/$codigo/libre');
      if (resp.data == "") return null;
      return envioModel.fromOneJson(resp.data);
  }

  @override
  Future<dynamic> registrarLoteLote(List<EnvioModel> envios, int turnoID, String codigo) async {
    List<int> ids = envios.map((envio) => envio.id).toList();
    int utdId = obtenerUTDid();
    var listaIds = json.encode(ids);
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/turnosinterconexiones/$turnoID/lotes?paqueteId=$codigo',listaIds,null);
    return resp.data;
  }
}
