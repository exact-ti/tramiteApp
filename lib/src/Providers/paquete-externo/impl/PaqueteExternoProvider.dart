import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as prefix0;
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/IPaqueteExternoProvider.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class PaqueteExternoProvider implements IPaqueteExternoProvider {

  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UtdModel utdModel = new UtdModel();
  TipoPaqueteModel tipoPaqueteModel = new TipoPaqueteModel();
  PaqueteExterno paquete = new PaqueteExterno();

  @override
  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno) async{
    bool inactivos = false;
    Response resp = await req.get('/servicio-tramite/tipospaquetes?interno=$interno&mostrarInactivos=$inactivos');
    List<dynamic> tipoPaquetes = resp.data;
    List<TipoPaqueteModel> listTipoPaquete = tipoPaqueteModel.fromJson(tipoPaquetes);
    return listTipoPaquete;
  }

  @override
  Future<dynamic> importarPaquetesExternos(List<PaqueteExterno> paqueteExterno, TipoPaqueteModel tipoPaquete) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int utdId = umodel.id;
    int tipoPaqueteId = tipoPaquete.id;

    final formData = json.encode(paqueteExterno);

    Response resp = await req.post('/servicio-tramite/utds/$utdId/tipospaquetes/$tipoPaqueteId/importacion',formData,null);
    
    dynamic b = resp.data;

    return b;
  }

  @override
  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int utdId = umodel.id;

    Response resp = await req.get('/servicio-tramite/utds/$utdId/envios?interno=0&estadoId=1');
    List<dynamic> creados = resp.data;
    List<PaqueteExterno> creadosList = paquete.fromJsonCreados(creados);
    return creadosList;
  }

  @override
  Future<bool> custodiarPaquete(PaqueteExterno paqueteExterno) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int utdId = umodel.id;
    String codigo = paqueteExterno.paqueteId;

    Response resp = await req.post('/servicio-tramite/utds/$utdId/paquetes/$codigo/custodia',null,null);
    dynamic respdata = resp.data;
    bool b = respdata["data"];

    return b;
  }

  

}