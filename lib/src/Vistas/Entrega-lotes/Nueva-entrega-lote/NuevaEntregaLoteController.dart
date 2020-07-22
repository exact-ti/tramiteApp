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

class NuevoEntregaLotePageController {
  EntregaInterface entregaCore = new EntregaImpl(new EntregaProvider());
TurnoModel turnoModel =  new TurnoModel();
  Future<List<TurnoModel>> listarturnos(
      BuildContext context, String codigo) async {
      List<TurnoModel> listEnvio = new List();
    if (codigo == "") {
      return null;
    }
    dynamic turnos =await entregaCore.listarTurnosByCodigoLote(codigo);

    if (turnos["status"] == "success") {
       listEnvio = turnoModel.fromJson(turnos["data"]);
    }else{
      mostrarAlerta(context, turnos["message"], "Mensaje");
    }
    return listEnvio;
  }

  bool validarContiene(List<EnvioModel> lista,EnvioModel envio ){
    bool boleano = false;
    for(EnvioModel en in lista){
      if(en.id==envio.id){
        boleano= true;
      }
    }
    return boleano;
  }



  Future<EnvioModel> validarCodigo(
      String codigo, BuildContext context, List<EnvioModel> lista) async {
    EnvioModel envio = await entregaCore.listarValijaByCodigoLote(codigo);

    if (envio == null) {
      mostrarAlerta(
          context, "No es posible procesar el código", "Codigo Incorrecto");
    } else {
      if (validarContiene(lista,envio)) {
        mostrarAlerta(
            context, "La valija ya fue agregada al lote", "Codigo Validado");
        return null;
      }
    }

    return envio;
  }

  void confirmacionDocumentosValidados(List<EnvioModel> enviosvalidados,
      BuildContext context, int id, String codigo) async {
    dynamic respuesta = await entregaCore.registrarLoteLote(enviosvalidados, id,codigo);
       if(respuesta["status"] == "success"){
      confirmarAlerta(
          context, "Se ha registrado correctamente la valija", "Registro");
    } else {
      mostrarAlerta(
          context, respuesta["message"], "Mensaje");
    }
  }

  void confirmarAlerta(BuildContext context, String mensaje, String titulo) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () =>
                    Navigator.of(context).pushNamedAndRemoveUntil(
                "/envio-lote", (Route<dynamic> route) => false)
              )
            ],
          );
        });
  }
}
