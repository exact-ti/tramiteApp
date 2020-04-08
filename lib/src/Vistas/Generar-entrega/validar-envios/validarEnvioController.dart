import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class ValidacionController {
  EntregaInterface entregaInterface = new EntregaImpl(new EntregaProvider());
  Future<List<EnvioModel>> validacionEnviosController(int recorridoId) async {
    List<EnvioModel> envios =await entregaInterface.listarEnviosValidacion(recorridoId);
    return envios;
  }

  void confirmacionDocumentosValidados(
      List<EnvioModel> enviosvalidados, BuildContext context,int id) async {
    RecorridoModel recorrido = new RecorridoModel();
    recorrido.id= await entregaInterface.listarEnviosValidados(enviosvalidados,id);
    recorrido.indicepagina=1;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }

  Future<EnvioModel> validarCodigo(String codigo,int id,BuildContext context) async {
    EnvioModel envio = await entregaInterface.validarCodigo(codigo,id);
    if(envio == null){
    mostrarAlerta(context, "EL codigo no pertenece al recorrido","Codigo Incorrecto");
    }

    return envio;
  }
}
