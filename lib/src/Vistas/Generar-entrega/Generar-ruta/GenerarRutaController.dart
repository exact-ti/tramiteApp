
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';

class GenerarRutaController {


    RutaInterface rutaInterface = new RutaImpl( new RutaProvider());
    
    
    Future<List<RutaModel>>  listarMiRuta(int recorridoId) async {
       List<RutaModel> entregas =  await rutaInterface.listarMiruta(recorridoId);
        return entregas;
    }


}