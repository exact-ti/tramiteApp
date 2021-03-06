import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';

abstract class IPaqueteExternoProvider{

  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno);

  Future<dynamic> importarPaquetesExternos(List<PaqueteExterno> paqueteExterno, TipoPaqueteModel tipoPaquete);

  Future<List<PaqueteExterno>> listarPaquetesExternosCreados();

  Future<dynamic> custodiarPaquete(String paqueteExterno);

}