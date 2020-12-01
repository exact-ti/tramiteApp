import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  final NavigationService _navigationService = locator<NavigationService>();
  NotificacionInterface notificacionCore = NotificacionImpl(new NotificacionProvider());


  Future<List<EnvioModel>> listarEnviosRecojo(
      BuildContext context, int id, String codigo) async {
    _navigationService.showModal();
    List<EnvioModel> recorridos =
        await recorridoCore.enviosCoreRecojo(codigo, id);
    _navigationService.goBack();
    return recorridos;
  }

  Future<dynamic> listarEnviosEntrega(
      BuildContext context, int id, String codigo) async {
    _navigationService.showModal();
    dynamic recorridos = await recorridoCore.enviosCoreEntrega(codigo, id);
    _navigationService.goBack();
    return recorridos;
  }

  Future<dynamic> recogerdocumentoRecojo(BuildContext context, int id,
      String codigo, String paquete, bool opcion) async {
    _navigationService.showModal();
    dynamic respuesta = await recorridoCore.registrarRecorridoRecojoCore(
        codigo, id, paquete, opcion);
    _navigationService.goBack();
    return respuesta;
  }

  Future<dynamic> recogerdocumentoEntrega(BuildContext context, int id,
      String codigo, String paquete, bool opcion) async {
    _navigationService.showModal();
    dynamic respuesta = await recorridoCore.registrarRecorridoEntregaCore(
        codigo, id, paquete, opcion);
    _navigationService.goBack();
    return respuesta;
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;

    Navigator.of(context).pushNamed('/miruta', arguments: {
      'indicepagina': 2,
      'recorridoId': recorrido.id,
    });
  }

    Future enviarNotificacion(String paqueteId) async {
    return await notificacionCore.enviarNotificacionEnAusenciaRecojo(paqueteId);
  }
}
