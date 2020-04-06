import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';

class RecorridoInterface {

    

    Future<List<EnvioModel>> enviosCore(String codigo, int recorridoId, bool opcion){}

    Future<bool> registrarRecorridoCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion){}

    Future<bool> registrarEntregaPersonalizadaProvider(String dni,int recorridoId, String codigopaquete){}  

    }


