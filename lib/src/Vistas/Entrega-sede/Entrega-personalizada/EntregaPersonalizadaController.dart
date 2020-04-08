import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class EntregaPersonalizadaController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());


  void guardarEntrega(BuildContext context, int id, String dni, String paquete) async {
     bool repuesta = await recorridoCore.registrarEntregaPersonalizadaProvider(dni, id, paquete);
     if(repuesta){
      mostrarAlerta(context,"Se ha registrado satisfactoriamente","Registro");
     }else{
      mostrarAlerta(context,"El codigo del paquete ha sido incorrecto","Registro incorrecto");
     }
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntregaRegularPage(recorridopage: recorrido),
        ));
  }
}
