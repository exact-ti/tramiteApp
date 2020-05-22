import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Generar-ruta/GenerarRutaPage.dart';

class ListarTurnosController {
  EntregaInterface entregaInterface = new EntregaImpl(new EntregaProvider());

  Future<List<EntregaModel>> listarentregasController() async {
    List<EntregaModel> entregas = await entregaInterface.listarEntregas();
    return entregas;
  }

  void onSearchButtonPressed(BuildContext context, EntregaModel entrega) {
    RecorridoModel recorridoModel = new RecorridoModel();
    recorridoModel.id = entrega.id;
    recorridoModel.indicepagina=entrega.estado.id;
    if (entrega.estado.id == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GenerarRutaPage(recorridopage: recorridoModel),
          ));
    }else{
            Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EntregaRegularPage(recorridopage: recorridoModel),
          ));
    }
  }
}
