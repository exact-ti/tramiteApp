import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';

class ListarEnviosController {
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioInterSedeModel>> listarentregasInterSedeController(
      int switched) async {
    List<EnvioInterSedeModel> entregas =  await intersedeInterface.listarIntersedesUsuario(switched);
    return entregas;
  }

  Future<bool> onSearchButtonPressed(
      BuildContext context, EnvioInterSedeModel enviomodel) async {
    bool respuesta =
        await intersedeInterface.iniciarEntregaIntersede(enviomodel.utdId);
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
