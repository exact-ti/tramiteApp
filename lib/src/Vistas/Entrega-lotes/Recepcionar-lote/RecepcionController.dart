import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
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

  Future<List<EnvioModel>> listarEnviosLotes(
      BuildContext context, String codigo) async {
    if (codigo == "") {
      return null;
    }

    List<EnvioModel> recorridos = await recepcionInterface.enviosCore(codigo);

    return recorridos;
  }

  Future<bool> recogerdocumentoLote(
      BuildContext context, String codigo, String paquete) async {
    _navigationService.showModal();

    bool respuesta = await recepcionInterface.recibirLote(codigo, paquete);
    _navigationService.goBack();

    return respuesta;
  }
}
