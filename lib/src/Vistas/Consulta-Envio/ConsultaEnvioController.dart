import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/consultas/impl/ConsultaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';

class ConsultaEnvioController {
  ConsultaInterface consultaCore = new ConsultaImpl(new ConsultaProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context, String paquete,
      String remitente, String destinatario, bool opcion) async {
    List<EnvioModel> turnos =
        await consultaCore.consultarByPaqueteAndDestinatarioAndRemitente(
            paquete, remitente, destinatario, opcion);

    if (turnos == null) {
      notificacion(context, "error", "EXACT", "No hay turnos asignados");
    }
    return turnos;
  }
}
