import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IPaqueteProvider.dart';

class PaqueteProvider implements IPaqueteProvider {

  Requester req = Requester();

  @override
  Future<bool> validarPaqueteSobrePorCodigo(String texto) async {
    Response resp = await req.get('/servicio-tramite/tipospaquetes/${TipoEstadoEnum.TIPO_PAQUETE_SOBRE}/paquetes/parauso?codigo=$texto');
    return resp.data;
  }
}
