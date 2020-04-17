import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class RecepcionInterController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      String codigo) async {
    List<EnvioModel> recorridos =  await intersedeInterface.listarRecepcionesByCodigo(codigo);
        if(recorridos.isEmpty){
            mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
        }
    return recorridos;
  }

  void recogerdocumento(BuildContext context,
      EnvioInterSedeModel envioInterSedeModel, String codigo, String paquete) async {
    bool respuesta = await intersedeInterface.registrarRecojoIntersedeProvider(codigo, envioInterSedeModel, paquete);
    if(respuesta==false){
      mostrarAlerta(context,"No se pudo completar la operación", "Código incorrecto");
    }

  }

}
