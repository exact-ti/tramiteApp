
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

class RecorridoPropioController {


    EntregaInterface entregaInterface = new EntregaImpl( new EntregaProvider());
    
    
    Future<List<RecorridoModel>>  listarRecorridosController() async {
       List<RecorridoModel> recorridos =  await entregaInterface.listarRecorridosUsuario();
        return recorridos;
    }


}