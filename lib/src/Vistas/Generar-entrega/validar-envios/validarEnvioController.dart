
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

class ValidacionController {


    EntregaInterface entregaInterface = new EntregaImpl( new EntregaProvider());
    
    
    Future<List<EnvioModel>>  validacionEnviosController(int recorridoId) async {
       List<EnvioModel> envios =  await entregaInterface.listarEnviosValidacion(recorridoId);
        return envios;
    }


}