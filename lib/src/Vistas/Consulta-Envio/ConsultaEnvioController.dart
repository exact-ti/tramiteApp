import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Consulta/ConsultaInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/consultas/impl/ConsultaProvider.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

import 'package:tramiteapp/src/Util/utils.dart';

class ConsultaEnvioController {

  ConsultaInterface consultaCore = new ConsultaImpl(new ConsultaProvider());


  Future<List<EnvioModel>> listarEnvios(
      BuildContext context, String paquete, String remitente, String destinatario, bool opcion) async {
    List<EnvioModel> turnos =await consultaCore.consultarByPaqueteAndDestinatarioAndRemitente(paquete, remitente, destinatario,opcion);

    if (turnos == null) {
      mostrarAlerta(context, "No hay turnos asignados", "Mensaje");
    }
    return turnos;
  }


}
