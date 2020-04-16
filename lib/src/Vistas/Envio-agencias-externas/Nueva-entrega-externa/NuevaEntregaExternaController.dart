import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';


class NuevoAgendaExternaController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =new InterSedeImpl(new InterSedeProvider());
  IAgenciasExternasInterface agenciacore = new AgenciasExternasImpl(new AgenciaExternaProvider());

    Future<List<EnvioModel>> listarEnviosEntrega(BuildContext context,
      String codigo) async {
       ///////////////
    List<EnvioModel> recorridos= await agenciacore.listarEnviosAgenciasByCodigo(codigo);

    if (recorridos.isEmpty) {
      mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
    }
    return recorridos;
  }

    Future<EnvioModel> validarCodigoEntrega(
      String codigo, BuildContext context) async {
    EnvioModel envio;/* = await agenciacore.validarCodigoAgencia(codigo, id);*/
    if (envio == null) {
      mostrarAlerta(
          context, "EL codigo no pertenece al recorrido", "Codigo Incorrecto");
    }

    return envio;
  }



  void confirmacionDocumentosValidadosEntrega(
     
      List<EnvioModel> enviosvalidados,
      BuildContext context,

      String codigo) async {
    RecorridoModel recorrido = new RecorridoModel();
    recorrido.id = await agenciacore.listarEnviosAgenciasValidados(enviosvalidados, codigo);

    confirmarAlerta(context, "Se ha registrado correctamente el envio", "Registro");
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
                  onPressed: () => Navigator.of(context).pushNamed('/envios-agencia'),
                  )
            ],
          );
        });
  }
}
