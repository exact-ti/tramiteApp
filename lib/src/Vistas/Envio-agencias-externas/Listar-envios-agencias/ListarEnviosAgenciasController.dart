
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';




class ListarEnviosAgenciasController {
  IAgenciasExternasInterface agenciacore = new AgenciasExternasImpl(new AgenciaExternaProvider());

  Future<List<EnvioInterSedeModel>> listarentregasInterSedeController() async {
    List<EnvioInterSedeModel> entregas =await agenciacore.listarEnviosAgenciasUsuario();
    return entregas;
  } 

  void onSearchButtonPressed(BuildContext context, EnvioInterSedeModel enviomodel)async {
    print("Entra al controller");
    /*bool respuesta = await intersedeInterface.iniciarEntregaIntersede(enviomodel.utdId);
    if(respuesta){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoIntersedePage(envioInterSede: enviomodel),
      ),
    );
    }else{
      mostrarAlerta( context, "No se pudo iniciar la entrega", "Incorrecto Inicio");
    }*/

  }
}
