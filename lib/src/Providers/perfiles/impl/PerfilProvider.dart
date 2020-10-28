import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IPerfilProvider.dart';

class PerfilProvider implements IPerfilProvider {
  String _prefix = "/servicio-perfil";

  Requester req = Requester();

  @override
  Future<dynamic> listarTipoPerfilByPerfil() async {
    Response resp = await req.get(_prefix + '/tiposperfiles/usuarioautenticado');
    return resp.data;
  }
}
