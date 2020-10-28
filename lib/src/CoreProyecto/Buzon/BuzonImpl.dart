
import 'package:tramiteapp/src/CoreProyecto/Buzon/BuzonInterface.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';

class BuzonImpl implements BuzonInterface {

  IBuzonProvider buzonProvider;

  BuzonImpl(IBuzonProvider buzonProvider){
    this.buzonProvider = buzonProvider;
  }
  
  @override
  Future<List<BuzonModel>> listarBuzonesPorIds(List<int> ids) async {
    return await buzonProvider.listarBuzonesPorIds(ids);
  }

  @override
  Future<List<BuzonModel>> listarBuzones() async {
    return await buzonProvider.listarBuzonesDelUsuarioAutenticado();
  }

}