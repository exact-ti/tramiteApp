import 'package:tramiteapp/src/CoreProyecto/EntregaLote/EntregaLoteInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Providers/lotes/IEntregaLoteProvider.dart';

class EntregaLoteImpl implements EntregaLoteInterface{

  
  IEntregaLoteProvider entregaLote;

  EntregaLoteImpl(IEntregaLoteProvider entregaLote){
    this.entregaLote = entregaLote;
  }
  
  @override
  Future<List<EntregaLoteModel>> listarLotesActivos() async {
    List<EntregaLoteModel> entregas = await entregaLote.listarLotesActivos();
    return entregas;
  }

  @override
  Future<List<EntregaLoteModel>> listarLotesPorRecibir() async {
    List<EntregaLoteModel> entregas = await entregaLote.listarLotesPorRecibir();
    return entregas;
  }
  
}