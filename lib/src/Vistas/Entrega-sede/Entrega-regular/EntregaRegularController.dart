import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      int id, String codigo, bool opcion) async {
    List<EnvioModel> recorridos =
        await recorridoCore.enviosCore(codigo, id, opcion);
        if(recorridos.isEmpty){
            mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
        }
    return recorridos;
  }

  void recogerdocumento(BuildContext context,
      int id, String codigo, String paquete, bool opcion) async {
    bool respuesta = await recorridoCore.registrarRecorridoCore(codigo, id, paquete, opcion);
    if(respuesta==false){
      mostrarAlerta(context,"No se pudo completar la operación", "Código incorrecto");
    }

  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }
}
