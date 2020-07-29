import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';

import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';

import 'package:tramiteapp/src/Util/utils.dart';

class NuevoEntregaLotePageController {
  EntregaInterface entregaCore = new EntregaImpl(new EntregaProvider());
  TurnoModel turnoModel = new TurnoModel();
  Future<List<TurnoModel>> listarturnos(
      BuildContext context, String codigo) async {
    List<TurnoModel> listEnvio = new List();
    if (codigo == "") {
      return null;
    }
    dynamic turnos = await entregaCore.listarTurnosByCodigoLote(codigo);

    if (turnos["status"] == "success") {
      listEnvio = turnoModel.fromJson(turnos["data"]);
    } else {
      notificacion(context, "error", "EXACT", turnos["message"]);
    }
    return listEnvio;
  }

  bool validarContiene(List<EnvioModel> lista, EnvioModel envio) {
    bool boleano = false;
    for (EnvioModel en in lista) {
      if (en.id == envio.id) {
        boleano = true;
      }
    }
    return boleano;
  }

  Future<EnvioModel> validarCodigo(
      String codigo, BuildContext context, List<EnvioModel> lista) async {
    EnvioModel envio = await entregaCore.listarValijaByCodigoLote(codigo);

    if (envio == null) {
      notificacion(
          context, "error", "EXACT", "No es posible procesar el código");
    } else {
      if (validarContiene(lista, envio)) {
        notificacion(
            context, "error", "EXACT", "La valija ya fue agregada al lote");
        return null;
      }
    }

    return envio;
  }

  void confirmacionDocumentosValidados(List<EnvioModel> enviosvalidados,
      BuildContext context, int id, String codigo) async {
    dynamic respuesta =
        await entregaCore.registrarLoteLote(enviosvalidados, id, codigo);
    if (respuesta["status"] == "success") {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha registrado correctamente la valija");
      if (respuestatrue != null) {
        if (respuestatrue) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/envio-lote", (Route<dynamic> route) => false);
        }
      }
    } else {
      notificacion(context, "error", "EXACT", respuesta["message"]);
    }
  }
}
