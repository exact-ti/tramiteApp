import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';
import '../IPalomarProvider.dart';

class PalomarProvider implements IPalomarProvider {
  UtdModel utdModel = new UtdModel();
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  PalomarModel palomarModel = new PalomarModel();

  @override
  Future<dynamic> listarPalomarByCodigo(String codigo) async {
    try{
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.post('/servicio-tramite/utds/$id/paquetes/$codigo/clasificacion',null,null);
    dynamic palomardata = resp.data;
    return palomardata;
    }catch(e){
      return null;
    }
  }

}