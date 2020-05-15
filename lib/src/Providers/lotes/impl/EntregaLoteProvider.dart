import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Providers/lotes/IEntregaLoteProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class EntregaLoteProvider implements IEntregaLoteProvider{
  
  final _prefs = new PreferenciasUsuario();
  UtdModel utdModel = new UtdModel();
  Requester req = Requester();
  EntregaLoteModel entregaLoteModel = new EntregaLoteModel();
  
  @override
  Future<List<EntregaLoteModel>> listarLotesActivos() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/lotesactivos');
    List<dynamic> entregas = resp.data;
    List<EntregaLoteModel> listEntrega = entregaLoteModel.fromJsonValidar(entregas);
    return listEntrega;
  }

    @override
  Future<bool> iniciarEntregaLote(int utdDestino) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post(
        '/servicio-tramite/utds/$id/utdsdestinos/$utdDestino/lotes/inicio',
        null,
        null);
    if (resp.data) {
      return true;
    }
    return false;
  }

  @override
  Future<List<EntregaLoteModel>> listarLotesPorRecibir() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/lotes/recepcion');
    List<dynamic> entregas = resp.data;
    List<EntregaLoteModel> listEntrega = entregaLoteModel.fromJsonValidar(entregas);
    return listEntrega;
  }

}