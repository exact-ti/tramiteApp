import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/consultas/impl/ConsultaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';

class ConsultaEnvioController {
  ConsultaInterface consultaCore = new ConsultaImpl(new ConsultaProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  EnvioInterface envioCore = new EnvioImpl(
      new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context, String paquete,
      String remitente, String destinatario, bool opcion) async {
    _navigationService.showModal();
    List<EnvioModel> enviosAsociados =
        await consultaCore.consultarByPaqueteAndDestinatarioAndRemitente(
            paquete, remitente, destinatario, opcion);
    _navigationService.goBack();
    
    if (enviosAsociados.isEmpty)
      notificacion(context, "error", "EXACT", "No hay envíos asignados");

    return enviosAsociados;
  }

  Future<dynamic> retirarEnvio(String envioId, String motivo) async {
    dynamic repuesta = await envioCore.retirarEnvio(envioId, motivo);
    return repuesta;
  }
}
