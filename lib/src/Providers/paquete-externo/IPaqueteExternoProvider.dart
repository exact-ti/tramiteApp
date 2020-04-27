import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';

abstract class IPaqueteExternoProvider{

  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno);

  Future<bool> importarPaquetesExternos(List<PaqueteExterno> paqueteExterno, TipoPaqueteModel tipoPaquete);

  Future<List<PaqueteExterno>> listarPaquetesExternosCreados();

  Future<bool> custodiarPaquete(PaqueteExterno paqueteExterno);

}