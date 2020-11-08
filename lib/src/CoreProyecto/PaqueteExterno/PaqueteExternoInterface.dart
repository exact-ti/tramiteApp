
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';

abstract class PaqueteExternoInterface {

  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno);
  
  Future<dynamic> importarPaquetesExternos(List<PaqueteExterno> paqueteExterno, TipoPaqueteModel tipoPaquete);

  Future<List<PaqueteExterno>> listarPaquetesExternosCreados();

  Future<bool> custodiarPaquete(String paqueteExterno);
  
}