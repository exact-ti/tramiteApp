

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
    List<TipoPaqueteModel> tipoPaqueteModelList = await paqueteExterno.listarPaquetesPorTipo(false);
    return tipoPaqueteModelList;
  }

  @override
  Future<bool> importarPaquetesExternos(List<PaqueteExterno> paqueteExternoList, TipoPaqueteModel tipoPaquete) async {
    bool resp = await paqueteExterno.importarPaquetesExternos(paqueteExternoList, tipoPaquete);
    return resp;
  }

  @override
  Future<List<PaqueteExterno>> listarPaquetesExternosCreados() async {
    List<PaqueteExterno> paquetes = await paqueteExterno.listarPaquetesExternosCreados();
    return paquetes;
  }

  @override
  Future<bool> custodiarPaquete(PaqueteExterno paquete) async {
    bool resp = await paqueteExterno.custodiarPaquete(paquete);
    return resp;
  }

}