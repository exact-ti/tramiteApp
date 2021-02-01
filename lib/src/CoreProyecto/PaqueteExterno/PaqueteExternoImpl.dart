

import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Providers/paquete-externo/IPaqueteExternoProvider.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';

class PaqueteExternoImpl implements PaqueteExternoInterface {

  IPaqueteExternoProvider paqueteExterno;

  PaqueteExternoImpl(IPaqueteExternoProvider paqueteExterno){
    this.paqueteExterno = paqueteExterno;
  }

  @override
  Future<List<TipoPaqueteModel>> listarPaquetesPorTipo(bool interno) async{
    return await paqueteExterno.listarPaquetesPorTipo(false);
  }

  @override
  Future<dynamic> importarPaquetesExternos(List<PaqueteExterno> paqueteExternoList, TipoPaqueteModel tipoPaquete) async {
    return await paqueteExterno.importarPaquetesExternos(paqueteExternoList, tipoPaquete);
  }

  @override
  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    return await paqueteExterno.listarPaquetesExternosCreados();
  }

  @override
  Future<dynamic> custodiarPaquete(String paquete) async {
    return await paqueteExterno.custodiarPaquete(paquete);
  }

}