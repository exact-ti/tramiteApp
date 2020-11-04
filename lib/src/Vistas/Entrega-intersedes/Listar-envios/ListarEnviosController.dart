import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ListarEnviosController {
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<EnvioInterSedeModel>> listarentregasInterSedeController(
      bool porRecibir) async {
    List<EnvioInterSedeModel> entregas =
        await intersedeInterface.listarIntersedesUsuario(porRecibir);
    return entregas;
  }

  Future<bool> onSearchButtonPressed(BuildContext context, EnvioInterSedeModel enviomodel) async {
    _navigationService.showModal();
    bool respuesta = await intersedeInterface.iniciarEntregaIntersede(enviomodel.utdId);
    _navigationService.goBack();

    return respuesta;
  }
}
