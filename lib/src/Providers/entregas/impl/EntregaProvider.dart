import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';

import '../IEntregaProvider.dart';


class EntregaProvider implements IEntregaProvider {
  
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  EntregaModel entregaModel = new EntregaModel();
  EnvioModel envioModel = new EnvioModel();
  RecorridoModel recorridoModel = new RecorridoModel();
  UtdModel utdModel = new UtdModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  @override
  Future<List<EntregaModel>> listarEntregaporUsuario() async {
    //agregar campos para busqueda
    Map<String,dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    int tipoentregaId  = entregaPisoId;
    Response resp = await req.get('/servicio-tramite/utds/$id/tiposentregas/$tipoentregaId/entregas/activas');
    List<dynamic> entregas = resp.data;
    List<EntregaModel> listEntrega = entregaModel.fromJson(entregas);
    return listEntrega;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoUsuario() async {
    Response resp = await req.get('/servicio-tramite/recorridos');
    List<dynamic> recorridos = resp.data;
    List<RecorridoModel> listRecorrido = recorridoModel.fromJson(recorridos);
    return listRecorrido;
  }

  @override
  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId) async {
    Response resp = await req.get('/servicio-tramite/recorridos/$recorridoId/envios/paraentrega');
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoporNombre(String nombre) async{
    Map<String,dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/recorridos?nombre=$nombre');
    List<dynamic> recorridos = resp.data;
    List<RecorridoModel> listEntrega = recorridoModel.fromJson(recorridos);
    return listEntrega;
  }

}