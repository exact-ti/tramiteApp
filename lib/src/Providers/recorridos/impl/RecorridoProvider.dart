import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'dart:convert';
import '../IRecorridoProvider.dart';

class RecorridoProvider implements IRecorridoProvider {
  Requester req = Requester();
  EnvioModel envioModel = new EnvioModel();
  TipoEntregaPersonalizadaModel tipopersonalizada = new TipoEntregaPersonalizadaModel();

  @override
  Future enviosEntregaProvider(String codigo, int id) async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/$id/areas/$codigo/envios/paraentrega');
    if (resp.data == "") return null;
    return resp.data;
  }

  @override
  Future<List<EnvioModel>> enviosRecojoProvider(
      String codigo, int recorridoId) async {
    try {
      Response resp = await req.get('/servicio-tramite/areas/$codigo/envios');
      if (resp.data == "") return null;
      return envioModel.fromJsonValidar(resp.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<dynamic> registrarEntregaProvider(
      String codigo, int recorridoId, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/areas/$codigo/paquetes/$codigopaquete/entrega',
        null,
        null);
    return resp.data;
  }

  @override
  Future<dynamic> registrarRecojoProvider(
      String codigo, int recorridoId, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/$recorridoId/areas/$codigo/paquetes/$codigopaquete/recojo',
        null,
        null);
    return resp.data;
  }

  @override
  Future<bool> registrarEntregaPersonalizadaProvider(
      String dni, String codigopaquete) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/paquetes/$codigopaquete/entregapersonalizada/tiposcargos/1?codigo_usuario=$dni',
        null,
        null);
    return resp.data;
  }

  @override
  Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada() async {
    bool interno = false;
    Response resp = await req.get('/servicio-tramite/tiposcargos?incluirInactivos=$interno');
    return tipopersonalizada.fromJson(resp.data);
  }

  @override
  Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(
      String firma, String codigopaquete) async {
    int utdId = obtenerUTDid();
    dynamic formato = new MediaType('image', 'png');
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(Base64Decoder().convert(firma),
          contentType: formato, filename: "file.png")
    });

    Response resp = await req.post(
        '/servicio-tramite/utds/$utdId/paquetes/$codigopaquete/entregapersonalizada/tiposcargos/2',
        formData,
        null);
    return resp.data;
  }
}
