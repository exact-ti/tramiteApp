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
    //PalomarModel palomar = palomarModel.fromOneJson(palomardata);
    return palomardata;
    }catch(e){
      return null;
    }
  }

  @override
  Future<PalomarModel> listarPalomarByCodigo2(String codigo)async {
      PalomarModel palomar = await palomarbycodigo(codigo);
    return palomar;
  }

  Future<PalomarModel> palomarbycodigo(String codigo) async {
    PalomarModel palomar = new PalomarModel();
    if(codigo=="abc"){
    palomar.id = 1; 
    palomar.codigo = "abc";
    palomar.fila = 1;
    palomar.columna = 2;
    palomar.tipo="area";
    }else{
      palomar=null;
    }
    return Future.delayed(new Duration(seconds: 1), () {
      return palomar;
    });
    

  }




}