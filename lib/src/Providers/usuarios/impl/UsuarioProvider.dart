import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import '../IUsuarioProvider.dart';
import 'dart:convert';


class UsuarioProvider implements IUsuariosProvider {
  
  Requester req = Requester();
  final _prefs = new PreferenciasUsuario();
  UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
  BuzonModel buzonModel = new BuzonModel();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  @override
  Future<List<UsuarioFrecuente>> listarUsuarioFrecuenteDelUsuarioAutenticado() async {
    //agregar campos para busqueda
    Map<String,dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
    int id = bznmodel.id;
    List<dynamic> configuraciones = json.decode(_prefs.configuraciones);
    List<ConfiguracionModel> configuration = configuracionModel.fromPreferencs(configuraciones);
    int cantidad = 0;
    for(ConfiguracionModel confi in configuration){
        if(confi.nombre=="CANTIDAD_RESULTADOS"){
            cantidad = int.parse(confi.valor);
        }
    }
    Response resp = await req.get('/servicio-tramite/buzones/$id/destinatariosfrecuentes?cantidad=$cantidad');
    List<dynamic> menus = resp.data;
    List<UsuarioFrecuente> listusuarios = usuarioFrecuente.fromJson(menus);
    print("dar");
    return listusuarios;
  }

  @override
  Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto) async{
    Response resp = await req.get('/servicio-tramite/buzones?filtro=$texto');
    List<dynamic> menus = resp.data;
    List<UsuarioFrecuente> listusuarios = usuarioFrecuente.fromJson(menus);
    print("dar");
    return listusuarios;
  }

}