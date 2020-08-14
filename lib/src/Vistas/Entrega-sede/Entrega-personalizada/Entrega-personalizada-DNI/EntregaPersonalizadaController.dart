import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';

class EntregaPersonalizadaController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());


  Future<bool> guardarEntrega(BuildContext context, String dni, String paquete) async {
     bool repuesta = await recorridoCore.registrarEntregaPersonalizadaProvider(dni, paquete);
     return repuesta;
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntregaRegularPage(recorridopage: recorrido),
        ));
  }
}
