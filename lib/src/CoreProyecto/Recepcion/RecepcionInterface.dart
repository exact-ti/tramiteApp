import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class RecepcionInterface {

    

    Future<List<EnvioModel>> enviosCore(String codigo){}

    Future<List<EnvioModel>> listarEnviosCore(){}

    Future<List<EnvioModel>> listarEnviosPrincipalCore(){}

    Future<bool> registrarRecorridoCore(String codigoArea, String codigoPaquete){}

    Future<bool> registrarLote(String codigoArea, String codigoPaquete){}

    Future<bool> recibirLote(String codigoArea, String codigoPaquete){}

    Future<bool> registrarEnvioCore(String codigoPaquete){}

    Future<bool> registrarEnvioPrincipalCore(String codigoPaquete){}
    
    Future<bool> registrarListaEnvioPrincipalCore(List<String> codigosPaquete){}

    }


