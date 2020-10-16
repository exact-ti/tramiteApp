import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IPaqueteProvider.dart';

class PaqueteProvider implements IPaqueteProvider {
  int indicepaquete = sobreId;

  Requester req = Requester();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  BuzonModel buzonModel = new BuzonModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  @override
  Future<bool> validarPaqueteSobrePorCodigo(String texto) async {
    Response resp = await req.get(
        '/servicio-tramite/tipospaquetes/$indicepaquete/paquetes/parauso?codigo=$texto');
    if (resp.data == false) {
      return false;
    } else {
      return true;
    }
  }
}
