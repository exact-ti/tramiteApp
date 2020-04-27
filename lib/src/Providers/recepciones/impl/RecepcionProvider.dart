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

  @override
  Future<List<EnvioModel>> listarenvios() async {
    Response resp = await req.get(
        '/servicio-tramite/recorridos/areas//envios/paraentrega');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidar(envio);
    return enviosMode;
  }

  @override
  Future<bool> registrarEnvioProvider(String codigopaquete) async{
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<EnvioModel>> listarenviosPrincipal() async{
    Response resp = await req.get(
        '/servicio-tramite/recorridos/areas//envios/paraentrega');
    if (resp.data == "") {
      return null;
    }
    List<dynamic> envio = resp.data;
    List<EnvioModel> enviosMode = envioModel.fromJsonValidarRecepcion(envio);
    return enviosMode;
  }

  @override
  Future<List<EnvioModel>> listarenviosPrincipal2() async {
    List<EnvioModel> listEnvio = await listarfake();
    return listEnvio;
  }

  Future<List<EnvioModel>> listarfake() async{
    List<EnvioModel> listarenvios = new List();
    EnvioModel envio1 = new EnvioModel();
    EnvioModel envio2 = new EnvioModel();
    envio1.observacion="San Isidro";
    envio1.usuario="Ronald Santos";
    envio1.codigoPaquete="541534";
    envio2.observacion="San Isidro";
    envio2.usuario="Ronald Santos";
    envio2.codigoPaquete="541534";
    listarenvios.add(envio1);
    listarenvios.add(envio2);

    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });

  }

  @override
  Future<bool> registrarEnvioPrincipalProvider(String codigopaquete) async {
    Response resp = await req.post(
        '/servicio-tramite/recorridos/areas/paquetes/$codigopaquete/entrega',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

}
