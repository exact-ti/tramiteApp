import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/consultas/impl/ConsultaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class ConsultaEnvioController {
  ConsultaInterface consultaCore = new ConsultaImpl(new ConsultaProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<EnvioModel>> listarEnvios(BuildContext context, String paquete,
      String remitente, String destinatario, bool opcion) async {
            _navigationService.showModal();

    List<EnvioModel> turnos = await consultaCore.consultarByPaqueteAndDestinatarioAndRemitente(
            paquete, remitente, destinatario, opcion);
          _navigationService.goBack();

    if (turnos == null) {
      notificacion(context, "error", "EXACT", "No hay turnos asignados");
    }
    return turnos;
  }
}
