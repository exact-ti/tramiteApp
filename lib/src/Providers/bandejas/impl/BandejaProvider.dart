import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IBandejaProvider.dart';


class BandejaProvider implements IBandejaProvider {

  Requester req = Requester();

  @override
  Future<bool> validarBandejaSobrePorCodigo(String texto) async{
    Response resp = await req.get('/servicio-tramite/areas?codigo=$texto');
    return resp.data;
  }

}