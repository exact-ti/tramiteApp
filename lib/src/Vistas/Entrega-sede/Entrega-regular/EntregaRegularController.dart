import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Generar-ruta/GenerarRutaPage.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      int id, String codigo, bool opcion) async {
    List<EnvioModel> recorridos = await recorridoCore.enviosCore(codigo, id, opcion);
    if(recorridos!=null){
      if(recorridos.length==0){
        return null;
      }
    }
    return recorridos;
  }

  Future< dynamic> recogerdocumentoRecojo(BuildContext context,
      int id, String codigo, String paquete, bool opcion) async {
     dynamic respuesta = await recorridoCore.registrarRecorridoRecojoCore(codigo, id, paquete, opcion);
      return respuesta;
  }

  Future<bool> recogerdocumentoEntrega(BuildContext context,
      int id, String codigo, String paquete, bool opcion) async {
    bool respuesta = await recorridoCore.registrarRecorridoEntregaCore(codigo, id, paquete, opcion);
      return respuesta;
  }



  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }
}
