import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Generar-ruta/GenerarRutaPage.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      EnvioInterSedeModel interSedeModel, String codigo) async {
    List<EnvioModel> recorridos =
        await intersedeInterface.listarEnviosByCodigo(codigo);
    if (recorridos != null) {
      if (recorridos.length == 0) {
        notificacion(
            context, "error", "EXACT", "No es posible procesar el código");
      }
    }

    return recorridos;
  }

  Future<List<EnvioModel>> listarEnviosEntrega(
      BuildContext context, String codigo) async {
    List<EnvioModel> recorridos =
        await intersedeInterface.listarEnviosByCodigo(codigo);

    if (recorridos == null || recorridos.length == 0) {
      notificacion(
          context, "error", "EXACT", "No es posible procesar el código");
    }
    return recorridos;
  }

  void recogerdocumento(
      int id, String codigo, String paquete, bool opcion) async {
    /* recorridoCore.registrarRecorridoCore(codigo, id, paquete, opcion);*/
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }

  Future<EnvioModel> validarCodigo(
      String codigo, int id, BuildContext context) async {
    EnvioModel envio; /*= await intersedeInterface.validarCodigo(codigo, id);*/
    if (envio == null) {
      notificacion(
          context, "error", "EXACT", "EL codigo no pertenece al recorrido");
    }

    return envio;
  }

  Future<EnvioModel> validarCodigoEntrega(
      String codigobandeja, String codigo, BuildContext context) async {
    EnvioModel envio =
        await intersedeInterface.validarCodigo(codigo, codigobandeja);
    if (envio == null) {
      notificacion(
          context, "error", "EXACT", "No es posible procesar el código");
    } else {
      notificacion(context, "success", "EXACT", "Envío agregado a la entrega");
    }

    return envio;
  }

  void confirmacionDocumentosValidados(
      EnvioInterSedeModel sede,
      List<EnvioModel> enviosvalidados,
      BuildContext context,
      int id,
      String codigo) async {
    dynamic respuesta = await intersedeInterface.listarEnviosValidadosInterSede(
        enviosvalidados, codigo);
    if (respuesta["status"] == "success") {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha registrado correctamente la valija");
      if (respuestatrue != null) {
        if (respuestatrue) {
          Navigator.of(context).pushNamed('/envio-interutd');
        }
      }
    } else {
      notificacion(context, "error", "EXACT", respuesta["message"]);
    }
  }

  void confirmacionDocumentosValidadosEntrega(List<EnvioModel> enviosvalidados,
      BuildContext context, String codigo) async {
    dynamic respuesta = await intersedeInterface.listarEnviosValidadosInterSede(
        enviosvalidados, codigo);
    if (respuesta["status"] == "success") {
      bool respuestatrue = await notificacion(context, "success", "EXACT",
          "Se ha registrado correctamente la valija");
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
