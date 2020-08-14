
import 'package:tramiteapp/src/Providers/dashboard/IDashboardProvider.dart';
import 'DashboardCoreInterface.dart';

class DashboardCoreImpl implements DashboardCoreInterface {

  IDashboardProvider dashboardProvider;

  DashboardCoreImpl(IDashboardProvider dashboardProvider){
    this.dashboardProvider = dashboardProvider;
  }

  @override
  Future<dynamic> consultarItems() async {
    dynamic envios = await dashboardProvider.listarIndicadores();
    return envios;
  }
}