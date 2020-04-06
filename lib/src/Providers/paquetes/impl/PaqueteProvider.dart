import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/TipoPaqueteEnum.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';
import '../IPaqueteProvider.dart';


class PaqueteProvider implements IPaqueteProvider {
  
  int indicepaquete = sobreId;

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
    Response resp = await req.get('/servicio-buzon/buzones/$id/destinatariosfrecuentes?cantidad=$cantidad');
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

  @override
  Future<bool> validarPaqueteSobrePorCodigo(String texto) async{

    var queryParameters = {
      'codigo': texto,
    };

    Response resp = await req.get('/servicio-tramite/tipospaquetes/$indicepaquete/paquetes/parauso?codigo=$texto');
    if(resp.data==false){
        return false;
    }else{
      return true;
    }      
      
  }

}