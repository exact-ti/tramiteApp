import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import '../IPalomarProvider.dart';

class PalomarProvider implements IPalomarProvider {
  
  Requester req = Requester();

  @override
  Future listarPalomarByCodigo(String codigo) async {
    int utdId = obtenerUTDid();
    Response resp = await req.post('/servicio-tramite/utds/$utdId/paquetes/$codigo/clasificacion',null,null);
    return  resp.data;
  }

}