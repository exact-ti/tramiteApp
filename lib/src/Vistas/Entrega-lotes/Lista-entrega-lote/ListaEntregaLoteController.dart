import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/EntregaLote/EntregaLoteImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/EntregaLote/EntregaLoteInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Providers/lotes/impl/EntregaLoteProvider.dart';

class ListaEntregaLoteController {


  EntregaLoteInterface entregaLote = new EntregaLoteImpl(new EntregaLoteProvider());

  Future<List<EntregaLoteModel>> listarLotesActivos() async {
    List<EntregaLoteModel> entregas = await entregaLote.listarLotesActivos();
    return entregas;
  }

  Future<List<EntregaLoteModel>> listarLotesPorRecibir() async {
    List<EntregaLoteModel> entregas = await entregaLote.listarLotesPorRecibir();
    return entregas;
  }

    Future<bool> onSearchButtonPressed(
      BuildContext context, EntregaLoteModel enviomodel) async {
    bool respuesta =
        await entregaLote.iniciarEntregaLote(enviomodel.utdId);
    /*if(respuesta){
        confirmarAlerta(context, "Se ha iniciado el envío correctamente", "Inicio Correcto");
    }else{
      mostrarAlerta( context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
    }*/
    return respuesta;
  }
  void confirmarAlerta(BuildContext context, String mensaje, String titulo) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
  
}