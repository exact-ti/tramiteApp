import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/impl/RecepcionProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class RecepcionController {

  RecepcionInterface recorridoCore = new RecepcionImpl(new RecepcionProvider());

  Widget labeltext(String mensaje){
  return Container(
    child: Text("$mensaje"),
    margin: const EdgeInsets.only(left: 15),
  );
  }

  Future<List<EnvioModel>> listarEnvios(
      BuildContext context,  String codigo, bool opcion) async {
    List<EnvioModel> recorridos =
        await recorridoCore.enviosCore(codigo, opcion);
    if (recorridos.isEmpty) {
      mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
    }
    return recorridos;
  }

  void recogerdocumento(BuildContext context, String codigo,
      String paquete, bool opcion) async {
    bool respuesta =
        await recorridoCore.registrarRecorridoCore(codigo, paquete, opcion);
    if (respuesta == false) {
      mostrarAlerta(
          context, "No se pudo completar la operación", "Código incorrecto");
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
