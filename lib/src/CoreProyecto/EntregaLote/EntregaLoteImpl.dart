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
    return await entregaLote.listarLotesActivos();
  }

  @override
  Future<List<EntregaLoteModel>> listarLotesPorRecibir() async {
    return await entregaLote.listarLotesPorRecibir();
  }

    @override
  Future<bool> iniciarEntregaLote(int utdDestino) async{
    return await entregaLote.iniciarEntregaLote(utdDestino);
  }
  
}