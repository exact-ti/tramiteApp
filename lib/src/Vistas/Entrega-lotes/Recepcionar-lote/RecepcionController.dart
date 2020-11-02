import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/Providers/recepciones/impl/RecepcionProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class RecepcionControllerLote {
  RecepcionInterface recepcionInterface =
      new RecepcionImpl(new RecepcionProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Widget labeltext(String mensaje) {
    return Container(
      child: Text("$mensaje"),
      margin: const EdgeInsets.only(left: 15),
    );
  }

  Future listarEnviosLotes(String codigo) async {
    return await recepcionInterface.listarEnviosByLote(codigo);
  }

  Future<bool> recogerdocumentoLote(
      BuildContext context, String codigoLote, String codigoValija) async {
    _navigationService.showModal();

    bool respuesta = await recepcionInterface.recibirLote(codigoLote, codigoValija);
    _navigationService.goBack();

    return respuesta;
  }
}
