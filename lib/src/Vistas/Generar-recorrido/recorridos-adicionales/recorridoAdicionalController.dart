
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

class RecorridoAdicionalController {

    EntregaInterface entregaInterface = new EntregaImpl( new EntregaProvider());

    Future<List<RecorridoModel>>  recorridosController(String nombre) async {
        List<RecorridoModel> entregas =  await entregaInterface.listarRecorridosporNombre(nombre);
        return entregas;
    }

}