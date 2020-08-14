import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<EnvioModel>> listarEnviosEntrega(
      BuildContext context, String codigo) async {
    _navigationService.showModal();

    List<EnvioModel> recorridos =
        await intersedeInterface.listarEnviosByCodigo(codigo);

    _navigationService.goBack();

    return recorridos;
  }

  Future<EnvioModel> validarCodigoEntrega(
      String codigobandeja, String codigo, BuildContext context) async {
    _navigationService.showModal();

    EnvioModel envio =
        await intersedeInterface.validarCodigo(codigo, codigobandeja);

    _navigationService.goBack();

    return envio;
  }

  void confirmacionDocumentosValidadosEntrega(List<EnvioModel> enviosvalidados,
      BuildContext context, String codigo) async {
    _navigationService.showModal();

    dynamic respuesta = await intersedeInterface.listarEnviosValidadosInterSede(
        enviosvalidados, codigo);

    _navigationService.goBack();

    if (respuesta["status"] == "success") {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha registrado correctamente la valija");

      _navigationService.goBack();

      if (respuestatrue != null) {
        if (respuestatrue) {
          Navigator.of(context).pushNamed('/envio-interutd');
        }
      }
    } else {
      notificacion(context, "error", "EXACT", respuesta["message"]);
    }
  }
}
