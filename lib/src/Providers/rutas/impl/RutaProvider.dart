import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import '../IRutaProvider.dart';

class RutaProvider implements IRutaProvider {
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  RutaModel rutaModel = new RutaModel();
  RecorridoModel recorridoModel = new RecorridoModel(); 
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();


  @override
  Future<List<RutaModel>> listarMiRuta(int recorridoId) async {
    Response resp = await req.get('/servicio-tramite/recorridos/$recorridoId/areas');
    List<dynamic> rutas = resp.data;
    List<RutaModel> listrutas = rutaModel.fromJson(rutas);
    return listrutas;
  }

  @override
  Future<bool> iniciarRecorrido(int recorridoId) async{
    Response resp = await req.post('/servicio-tramite/recorridos/$recorridoId/inicio',null,null);
    if(resp.data==false){
        return false;
    }else{
      return true;
    }
  }

    @override
  Future<bool> terminarRecorrido(int recorridoId) async{
    Response resp = await req.post('/servicio-tramite/recorridos/$recorridoId/termino',null,null);
    if(resp.data==false){
        return false;
    }else{
      return true;
    }
  }

  
}
