import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'IDashboardProvider.dart';


class DashboardProvider implements IDashboardProvider {
  
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  BuzonModel buzonModel = new BuzonModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  @override
  Future<dynamic> listarIndicadores() async{
      Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    Response resp = await req.get('/servicio-tramite/buzones/$id/indicadores');
    dynamic respdata = resp.data;
    dynamic respdatalist = respdata["data"];
    return respdatalist;
  }

}