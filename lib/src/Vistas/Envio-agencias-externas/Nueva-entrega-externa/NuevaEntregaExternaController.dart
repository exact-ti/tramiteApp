import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';

class NuevoEntregaExternaController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());
  IAgenciasExternasInterface agenciacore =
      new AgenciasExternasImpl(new AgenciaExternaProvider());
  EnvioModel envioModel = new EnvioModel();
  Future<List<EnvioModel>> listarEnviosEntrega(
      BuildContext context, String codigo) async {
    List<EnvioModel> listEnvio = new List();
    dynamic recorridos = await agenciacore.listarEnviosAgenciasByCodigo(codigo);
    if (recorridos["status"] == "success") {
      dynamic datapalomar = recorridos["data"];
      listEnvio = envioModel.fromJsonValidar(datapalomar);
    } else {
      notificacion(context, "error", "EXACT", recorridos["message"]);
      listEnvio = [];
    }
    /*     if (recorridos != null) {
      if (recorridos.length == 0) {
        mostrarAlerta(context, "No es posible procesar el código", "Mensaje");
      }
    } */
    return listEnvio;
  }

  Future<EnvioModel> validarCodigoEntrega(
      String bandeja, String codigo, BuildContext context) async {
    EnvioModel envio = await agenciacore.validarCodigoAgencia(bandeja, codigo);
    if (envio == null) {
      notificacion(
          context, "error", "EXACT", "No es posible procesar el código");
    } else {
      notificacion(context, "success", "EXACT", "Envío agregado a la entrega");
    }

    return envio;
  }

  void confirmacionDocumentosValidadosEntrega(List<EnvioModel> enviosvalidados,
      BuildContext context, String codigo) async {
    if (codigo == "") {
      notificacion(
          context, "error", "EXACT", "El código de la valija es obligatorio");
    } else {
      if (enviosvalidados.length == 0) {
        notificacion(
            context, "error", "EXACT", "No hay envios para la agencia");
      } else {
        RecorridoModel recorrido = new RecorridoModel();
        recorrido.id = await agenciacore.listarEnviosAgenciasValidados(
            enviosvalidados, codigo);
        if (recorrido.id != null) {
          bool respuestatrue = await notificacion(context, "success", "EXACT",
              "Se ha registrado correctamente el envio");
          if (respuestatrue != null) {
            if (respuestatrue) {
              Navigator.of(context).pushNamed('/envios-agencia');
            }
          }
        } else {
          notificacion(
              context, "error", "EXACT", "No se  pudo registrar el envío");
        }
      }
    }
  }
}
