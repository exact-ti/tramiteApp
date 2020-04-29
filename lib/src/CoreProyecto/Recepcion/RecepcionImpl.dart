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
      String codigo, bool opcion) async {
    List<EnvioModel> envios = new List();
    if (opcion) {
      envios = await recepcion.recepcionJumboProvider(codigo);
    } else {
      envios = await recepcion.recepcionValijaProvider(codigo);
    }
    return envios;
  }

  @override
  Future<bool> registrarRecorridoCore(String codigoArea,
      String codigoPaquete, bool opcion) async {
    bool respuesta;

    if (opcion) {
      respuesta = await recepcion.registrarJumboProvider(codigoArea, codigoPaquete);
    } else {
      respuesta = await recepcion.registrarValijaProvider(codigoArea, codigoPaquete);
    }
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
    List<EnvioModel> envios = await recepcion.listarenviosPrincipal2();
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


}
