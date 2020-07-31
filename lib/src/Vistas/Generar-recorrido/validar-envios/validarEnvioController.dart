import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Generar-ruta/GenerarRutaPage.dart';

class ValidacionController {
  EntregaInterface entregaInterface = new EntregaImpl(new EntregaProvider());
  Future<List<EnvioModel>> validacionEnviosController(int recorridoId) async {
    List<EnvioModel> envios =
        await entregaInterface.listarEnviosValidacion(recorridoId);
    return envios;
  }

  void confirmacionDocumentosValidados(
      List<EnvioModel> enviosvalidados, BuildContext context, int id) async {
    RecorridoModel recorrido = new RecorridoModel();
    recorrido.id =
        await entregaInterface.listarEnviosValidados(enviosvalidados, id);
    recorrido.indicepagina = 1;
    bool respuestatrue = await notificacion(
        context, "success", "EXACT", "Se ha creado el recorrido correctamente");
    if (respuestatrue != null) {
      if (respuestatrue) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => GenerarRutaPage(recorridopage: recorrido),
            ),
            ModalRoute.withName('/recorridos'));
      }
    }
  }

  Future<EnvioModel> validarCodigo(
      String codigo, int id, BuildContext context) async {
    EnvioModel envio = await entregaInterface.validarCodigo(codigo, id);
    if (envio == null) {
      notificacion(
          context, "error", "EXACT", "EL código no pertenece al recorrido");
    }

    return envio;
  }
}
