import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/IRecepcionProvider.dart';
import 'RecepcionInterface.dart';

class RecepcionImpl implements RecepcionInterface {

  IRecepcionProvider recepcion;

  RecepcionImpl(IRecepcionProvider recepcion) {
    this.recepcion = recepcion;
  }

  @override
  Future<List<EnvioModel>> enviosCore(
      String codigo) async {
    List<EnvioModel> envios = new List();
      envios = await recepcion.recepcionJumboProvider(codigo);
    return envios;
  }

  @override
  Future<bool> registrarRecorridoCore(String codigoArea,
      String codigoPaquete) async {
    bool respuesta;
      respuesta = await recepcion.registrarJumboProvider(codigoArea, codigoPaquete);
    return respuesta;
  }

  @override
  Future<List<EnvioModel>> listarEnviosCore() async {
    List<EnvioModel> envios = await recepcion.listarenvios();
    return envios;
  }

  @override
  Future<bool> registrarEnvioCore(String codigoPaquete)async {
    bool respuesta= await recepcion.registrarEnvioProvider(codigoPaquete);
    return respuesta;
  }

  @override
  Future<List<EnvioModel>> listarEnviosPrincipalCore() async{
    List<EnvioModel> envios = await recepcion.listarenviosPrincipal();
    return envios;
  }

  @override
  Future<bool> registrarEnvioPrincipalCore(String codigoPaquete) async {
    bool respuesta= await recepcion.registrarEnvioPrincipalProvider(codigoPaquete);
    return respuesta;
  }

  @override
  Future<bool> registrarListaEnvioPrincipalCore(List<String> codigosPaquete) async {
     bool respuesta= await recepcion.registrarListaEnvioPrincipalProvider(codigosPaquete);
    return respuesta;
  }

  @override
  Future<bool> registrarLote(String codigoArea, String codigoPaquete) async {
    bool respuesta;
      respuesta = await recepcion.registrarJumboProvider(codigoArea, codigoPaquete);
    return respuesta;
  }

  @override
  Future<bool> recibirLote(String codigoLote, String codigoPaquete) async{
    bool respuesta;
      respuesta = await recepcion.recibirJumboProvider(codigoLote, codigoPaquete);
    return respuesta;
  }


}
