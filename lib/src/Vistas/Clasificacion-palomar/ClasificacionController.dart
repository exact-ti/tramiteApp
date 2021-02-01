import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarInterface.dart';
import 'package:tramiteapp/src/Providers/palomares/impl/PalomarProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ClasificacionController {
  PalomarInterface usuarioInterface = new PalomarImpl(new PalomarProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<dynamic> listarpalomarByCodigo(
      BuildContext context, String codigo) async {
    _navigationService.showModal();
    dynamic palomar = await usuarioInterface.listarPalomarByCodigo(codigo);
    _navigationService.goBack();
    return palomar;

  }
}
