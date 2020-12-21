import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ListarEnviosAgenciasController {
  IAgenciasExternasInterface agenciacore =
      new AgenciasExternasImpl(new AgenciaExternaProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<EnvioInterSedeModel>> listarAgenciasExternasController() async {
    List<EnvioInterSedeModel> entregas =
        await agenciacore.listarEnviosAgenciasUsuario();
    return entregas;
  }

  Future<bool> onSearchButtonPressed(
      BuildContext context, EnvioInterSedeModel enviomodel) async {
    _navigationService.showModal();

    bool respuesta = await agenciacore.iniciarEntregaAgencia(enviomodel);
    _navigationService.goBack();

    return respuesta;
  }

  Future<bool> registrarlista(BuildContext context, List<String> lista) async {
    bool respuesta = await agenciacore.iniciarEntregaListaAgencia(lista);
    return respuesta;
  }
}
