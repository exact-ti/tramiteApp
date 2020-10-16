import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IBandejaProvider.dart';


class BandejaProvider implements IBandejaProvider {
  
  int indicepaquete = sobreId;

  Requester req = Requester();

  @override
  Future<bool> validarBandejaSobrePorCodigo(String texto) async{
    Response resp = await req.get('/servicio-tramite/areas?codigo=$texto');
    if(resp.data==false){
        return false;
    }else{
      return true;
    }      
  }

}