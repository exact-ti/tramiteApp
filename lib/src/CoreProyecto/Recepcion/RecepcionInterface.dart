import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class RecepcionInterface {

    

    Future<List<EnvioModel>> enviosCore(String codigo, bool opcion){}

    Future<List<EnvioModel>> listarEnviosCore(){}

    Future<List<EnvioModel>> listarEnviosPrincipalCore(){}

    Future<bool> registrarRecorridoCore(String codigoArea, String codigoPaquete, bool opcion){}


    Future<bool> registrarEnvioCore(String codigoPaquete){}

        Future<bool> registrarEnvioPrincipalCore(String codigoPaquete){}
    

    }


