import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEntregaEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
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

  Future<bool> iniciarEntrega(
      BuildContext context, EnvioInterSedeModel enviomodel) async {
    _navigationService.showModal();
    bool respuesta =
        await intersedeInterface.iniciarEntregaIntersede(enviomodel);
    _navigationService.goBack();

    return respuesta;
  }

  IconData iconByEstadoEntrega(int estadoId) {
    switch (estadoId) {
      case EstadoEntregaEnum.CREADA:
        return IconsData.ICON_SEND_ARROW;
      case EstadoEntregaEnum.INICIADA:
        return null;
      case EstadoEntregaEnum.TERMINADA:
        return null;
      case EstadoEntregaEnum.TRANSITO:
        return IconsData.ICON_SEND_ARROW;
      default:
        return null;
    }
  }
}
