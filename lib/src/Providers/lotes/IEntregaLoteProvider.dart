import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';

abstract class IEntregaLoteProvider {

  Future<List<EntregaLoteModel>> listarLotesActivos();  

  Future<List<EntregaLoteModel>> listarLotesPorRecibir();

  Future<bool> iniciarEntregaLote(int utdDestino);  

  
}