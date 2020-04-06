import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

import '../IRecepcionProvider.dart';

class RecepcionProvider implements IRecepcionProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  EnvioModel envioModel = new EnvioModel();
  RecorridoModel recorridoModel = new RecorridoModel();
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  @override
  Future<List<EnvioModel>> recepcionJumboProvider(String codigo) async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/areas/$codigo/envios/paraentrega');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> recepcionValijaProvider(
      String codigo) async {
    Response resp = await req.get('/servicio-tramite/areas/$codigo/envios');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<bool> registrarJumboProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> registrarValijaProvider(
      String codigo, String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/$codigo/paquetes/$codigopaquete/recojo',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

}
