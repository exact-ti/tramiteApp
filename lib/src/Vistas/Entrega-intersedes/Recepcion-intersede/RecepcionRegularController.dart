import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class RecepcionInterController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());
  final NavigationService _navigationService = locator<NavigationService>();

  Future<dynamic> listarEnvios(BuildContext context, String codigo) async {
    dynamic dataEnvio = await intersedeInterface.listarRecepcionesByCodigo(codigo);
    return dataEnvio;
  }

  Future<dynamic> recogerdocumento(
      BuildContext context, String codigo, String paquete, bool opcion) async {
    _navigationService.showModal();

    dynamic respuesta = await intersedeInterface.registrarRecojoIntersedeProvider(codigo, paquete);
    _navigationService.goBack();

    return respuesta;
  }
}
