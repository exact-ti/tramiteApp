import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class RecepcionInterface {

    

    Future<List<EnvioModel>> enviosCore(String codigo, bool opcion){}

    Future<List<EnvioModel>> listarEnviosCore(){}

    Future<bool> registrarRecorridoCore(String codigoArea, String codigoPaquete, bool opcion){}


    Future<bool> registrarEnvioCore(String codigoPaquete){}

    }


