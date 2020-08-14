import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/impl/RecepcionProvider.dart';

class RecepcionController {
  RecepcionInterface recepcionInterface =
      new RecepcionImpl(new RecepcionProvider());

  Widget labeltext(String mensaje) {
    return Container(
      child: Text("$mensaje"),
      margin: const EdgeInsets.only(left: 15),
    );
  }

  Future<List<EnvioModel>> listarEnviosPrincipal() async {
    List<EnvioModel> envios =await recepcionInterface.listarEnviosPrincipalCore();
    return envios;
  }

  Future<bool> guardarLista(BuildContext context, List<String> lista) async {
    bool respuesta =await recepcionInterface.registrarListaEnvioPrincipalCore(lista);
    return respuesta;
  }
}
