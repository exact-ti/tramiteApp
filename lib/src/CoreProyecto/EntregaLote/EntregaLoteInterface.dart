import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';

class EntregaLoteInterface {

  Future<List<EntregaLoteModel>> listarLotesActivos(){}
  
  Future<List<EntregaLoteModel>> listarLotesPorRecibir(){}

  Future<bool> iniciarEntregaLote(int utdDestino) {}

}