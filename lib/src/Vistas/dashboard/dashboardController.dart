import 'package:tramiteapp/src/CoreProyecto/dashboard/DashboardCoreImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/dashboard/DashboardCoreInterface.dart';
import 'package:tramiteapp/src/Providers/dashboard/DashboardProvider.dart';

class DashboardController {
  DashboardCoreInterface dashboardCore =new DashboardCoreImpl(new DashboardProvider());
  Future<dynamic> listarItems() async {
    dynamic entregas =  await dashboardCore.consultarItems();
    return entregas;
  }

}
