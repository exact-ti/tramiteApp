import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';

class RegistrarEntregaPersonalizadaController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());


  Future<dynamic> guardarEntrega(BuildContext context, String firma, String paquete) async {
     dynamic repuesta = await recorridoCore.registrarEntregaPersonalizadaFirmaProvider(firma, paquete);
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
