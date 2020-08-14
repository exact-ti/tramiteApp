import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';

import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class NuevoEntregaLotePageController {
  EntregaInterface entregaCore = new EntregaImpl(new EntregaProvider());
  TurnoModel turnoModel = new TurnoModel();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<dynamic> listarturnos(BuildContext context, String codigo) async {
    List<TurnoModel> listEnvio = new List();
    if (codigo == "") {
      return null;
    }
    _navigationService.showModal();

    dynamic turnos = await entregaCore.listarTurnosByCodigoLote(codigo);

    _navigationService.goBack();

    return turnos;
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
    _navigationService.showModal();

    EnvioModel envio = await entregaCore.listarValijaByCodigoLote(codigo);
    _navigationService.goBack();

    return envio;
  }

  void confirmacionDocumentosValidados(List<EnvioModel> enviosvalidados,
      BuildContext context, int id, String codigo) async {
    _navigationService.showModal();

    dynamic respuesta =
        await entregaCore.registrarLoteLote(enviosvalidados, id, codigo);
    _navigationService.goBack();

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
