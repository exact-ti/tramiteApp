import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarInterface.dart';
import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:tramiteapp/src/Providers/palomares/impl/PalomarProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ClasificacionController {
  PalomarInterface usuarioInterface = new PalomarImpl(new PalomarProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<PalomarModel>> listarpalomarByCodigo(
      BuildContext context, String codigo) async {
    List<PalomarModel> palomares = new List();
    PalomarModel palomarModel = new PalomarModel();
    _navigationService.showModal();

    dynamic palomar = await usuarioInterface.listarPalomarByCodigo(codigo);
              _navigationService.goBack();

    if (palomar["status"] == "success") {
      dynamic datapalomar = palomar["data"];
      PalomarModel palomar2 = palomarModel.fromOneJson(datapalomar);
      palomares.add(palomar2);
      return palomares;
    } else {
      palomares = [];
    }
    return palomares;
  }
  //PalomarModel palomar = palomarModel.fromOneJson(palomardata);
}
