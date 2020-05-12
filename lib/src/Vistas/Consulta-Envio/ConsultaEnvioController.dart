import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';

import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

import 'package:tramiteapp/src/Util/utils.dart';

class ConsultaEnvioController {
  EntregaInterface entregaCore = new EntregaImpl(new EntregaProvider());


  Future<List<TurnoModel>> listarturnos(
      BuildContext context, String codigo) async {
    if (codigo == "") {
      return null;
    }
    List<TurnoModel> turnos =await entregaCore.listarTurnosByCodigoLote(codigo);

    if (turnos == null) {
      mostrarAlerta(context, "No hay turnos asignados", "Mensaje");
    }
    return turnos;
  }


}
