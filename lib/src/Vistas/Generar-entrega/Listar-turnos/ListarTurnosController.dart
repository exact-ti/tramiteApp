
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

class ListarTurnosController {


    EntregaInterface entregaInterface = new EntregaImpl( new EntregaProvider());
    
    
    Future<List<EntregaModel>>  listarentregasController() async {
       List<EntregaModel> entregas =  await entregaInterface.listarEntregas();
        return entregas;
    }


}