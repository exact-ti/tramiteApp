import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class RecepcionInterController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      String codigo) async {
    List<EnvioModel> recorridos =  await intersedeInterface.listarRecepcionesByCodigo(codigo);
    return recorridos;
  }

  Future<dynamic>  recogerdocumento(BuildContext context, String codigo, String paquete,bool opcion) async {
    dynamic respuesta = await intersedeInterface.registrarRecojoIntersedeProvider(codigo, paquete);
    return respuesta;
  }

}
