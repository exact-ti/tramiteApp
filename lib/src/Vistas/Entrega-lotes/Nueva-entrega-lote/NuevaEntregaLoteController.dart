import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';

import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/impl/EntregaProvider.dart';

import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';


class NuevoEntregaLotePageController {
  EntregaInterface entregaCore = new EntregaImpl(new EntregaProvider());

  Future<List<TurnoModel>> listarturnos(BuildContext context, String codigo) async {
    List<TurnoModel> turnos = await entregaCore.listarTurnosByCodigoLote(codigo);

    if (turnos.isEmpty) {
      mostrarAlerta(context, "No hay turnos asignados", "Mensaje");
    }
    return turnos;
  }




  Future<EnvioModel> validarCodigo(
      String codigo,BuildContext context) async {
    EnvioModel envio = await entregaCore.listarValijaByCodigoLote(codigo);
    if (envio == null) {
      mostrarAlerta(
          context, "EL codigo no pertenece a la entrega", "Codigo Incorrecto");
    }

    return envio;
  }


  void confirmacionDocumentosValidados(
      List<EnvioModel> enviosvalidados,
      BuildContext context,
      int id,
      String codigo) async {
    RecorridoModel recorrido = new RecorridoModel();
    bool respuesta= await entregaCore.registrarLoteLote(enviosvalidados, id);
    if(respuesta){
    confirmarAlerta(
        context, "Se ha registrado correctamente la valija", "Registro");
    }else{
    mostrarAlerta(
        context, "No se completó el registro de la entrega", "Mensaje");
    }

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
                onPressed: () =>
                    Navigator.of(context).pushNamed('/entrega-intersede'),
              )
            ],
          );
        });
  }
}
