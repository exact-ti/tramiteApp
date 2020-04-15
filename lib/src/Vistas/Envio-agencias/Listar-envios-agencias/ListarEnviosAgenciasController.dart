
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';



class ListarEnviosAgenciasController {
  EnvioInterface intersedeInterface =
      new EnvioImpl(new EnvioProvider(), new PaqueteProvider(),new BandejaProvider());

  Future<List<EnvioInterSedeModel>> listarentregasInterSedeController() async {
    List<EnvioInterSedeModel> entregas =await intersedeInterface.listarAgenciasUsuario();
    return entregas;
  } 

  void onSearchButtonPressed(BuildContext context, EnvioInterSedeModel enviomodel)async {
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
