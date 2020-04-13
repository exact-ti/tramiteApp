
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';

import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nuevo-intersede/EntregaRegularPage.dart';

class ListarEnviosController {
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioInterSedeModel>> listarentregasInterSedeController() async {
    List<EnvioInterSedeModel> entregas =
        await intersedeInterface.listarIntersedesUsuario();
    return entregas;
  }

  void onSearchButtonPressed(BuildContext context, EnvioInterSedeModel enviomodel)async {
    bool respuesta = await intersedeInterface.iniciarEntregaIntersede(enviomodel.utdId);
    if(respuesta){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoIntersedePage(envioInterSede: enviomodel),
      ),
    );
    }else{
      mostrarAlerta( context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
    }

  }
}
