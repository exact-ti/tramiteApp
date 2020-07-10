import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/Enumerator/TipoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/UtdModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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
  TurnoModel turnoModel = new TurnoModel();

  @override
  Future<List<EntregaModel>> listarEntregaporUsuario() async {
    //agregar campos para busqueda
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    int tipoentregaId = entregaPisoId;
    Response resp = await req.get('/servicio-tramite/utds/$id/recorridos');
    List<dynamic> entregas = resp.data;
    List<EntregaModel> listEntrega = entregaModel.fromJson(entregas);
    return listEntrega;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoUsuario() async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/utds/$id/turnos/usuarioautenticado');
    List<dynamic> recorridos = resp.data;
    List<RecorridoModel> listRecorrido = recorridoModel.fromJson(recorridos);
    return listRecorrido;
  }

  @override
  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId) async {
    Response resp = await req.get('/servicio-tramite/turnos/$recorridoId/envios/paraentrega');
    List<dynamic> envios = resp.data;
    List<EnvioModel> listEnvio = envioModel.fromJsonValidar(envios);
    return listEnvio;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridoporNombre(String nombre) async {
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp =await req.get('/servicio-tramite/utds/$id/turnos?nombre=$nombre');
    List<dynamic> recorridos = resp.data;
    List<RecorridoModel> listEntrega = recorridoModel.fromJson(recorridos);
    return listEntrega;
  }

  @override
  Future<int> listarEnviosValidados(
      List<EnvioModel> enviosvalidados, int id) async {
    List<int> ids = new List();
    for (EnvioModel envio in enviosvalidados) {
      ids.add(envio.id);
    }
    var listaIds = json.encode(ids);
    Response resp = await req.post('/servicio-tramite/turnos/$id/recorridos', listaIds, null);
    int idresp = resp.data;
    return idresp;
  }

  @override
  Future<EnvioModel> validarCodigoProvider(String codigo, int id) async {
    try{
    Response resp = await req.get('/servicio-tramite/turnos/$id/envios/paraagregaralrecorrido?paqueteId=$codigo');
    if(resp.data==""){
        return null;
    }
        dynamic envio = resp.data;
    EnvioModel envioMode = envioModel.fromOneJson(envio);
    return envioMode;
    }catch(e){
              return null;
    }

  }

  @override
  Future<dynamic> listarTurnosByCodigoLote(String codigo) async{
    Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    Response resp = await req.get('/servicio-tramite/tipospaquetes/lotes/$codigo/turnos?utdId=$id');
    dynamic envios = resp.data;
    //List<TurnoModel> listEnvio = turnoModel.fromJson(envios);
    return envios;
  }

  @override
  Future<EnvioModel> listarValijaByCodigoLote(String codigo) async{
    print("casadds");
    try{
    Response resp = await req.get('/servicio-tramite/tiposentregas/$entregaValijaId/valijas/$codigo/libre');
    if(resp.data==""){
        return null;
    }
        dynamic envio = resp.data;
    EnvioModel envioMode = envioModel.fromOneJson(envio);
    return envioMode;
    }catch(e){
              return null;
    }
  }

    @override
  Future<EnvioModel> listarValijaByCodigoLote2(String codigo) async{
   EnvioModel turnos = await listarfake2(codigo); 
    return turnos;
  }


  Future<EnvioModel> listarfake2(String codigo) async{

    if(codigo=="2000007"){
           EnvioModel  envio = new EnvioModel();
            envio.id  = 1;
            envio.codigoPaquete = "2000007";
          return envio;
    }

    if(codigo=="2000008"){
           EnvioModel  envio = new EnvioModel();
            envio.id  = 2;
            envio.codigoPaquete = "2000008";
          return envio;
    }
return null;

  }




  @override
  Future<dynamic> registrarLoteLote(List<EnvioModel> envios, int turnoID, String codigo) async{
    List<int> ids = new List();
for (EnvioModel envio in envios) {
      ids.add(envio.id);
    }
        Map<String, dynamic> utd = json.decode(_prefs.utd);
    UtdModel umodel = utdModel.fromPreferencs(utd);
    int id = umodel.id;
    var listaIds = json.encode(ids);
    Response resp = await req.post('/servicio-tramite/utds/$id/turnosinterconexiones/$turnoID/lotes?paqueteId=$codigo', listaIds, null);
    dynamic respuesta = resp.data;
    return respuesta; 
  }

  @override
  Future<List<TurnoModel>> listarTurnosByCodigoLote2(String codigo) async{
   List<TurnoModel> turnos = await listarfake(codigo); 
    return turnos;
  }


    Future<List<TurnoModel>> listarfake(String codigo) async{
    
    if(codigo=="A000001"){
    List<TurnoModel> listarenvios = new List();
    TurnoModel envio1 = new TurnoModel();
    TurnoModel envio2 = new TurnoModel();
    envio1.id=1;
    envio1.horaInicio=new DateFormat("HH:mm:ss").parse("09:30:30");
    envio1.horaFin=new DateFormat("HH:mm:ss").parse("13:30:30");
    envio2.id=2;
    envio2.horaInicio=new DateFormat("HH:mm:ss").parse("08:30:30");
    envio2.horaFin=new DateFormat("HH:mm:ss").parse("14:30:30");
    listarenvios.add(envio1);
    listarenvios.add(envio2);
    return Future.delayed(new Duration(seconds: 1), () {
      return listarenvios;
    });
    }

    return null;

  }
}
