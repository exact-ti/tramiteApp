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

import 'EntregaRegularPage.dart';

class EntregaregularController {
  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());
  InterSedeInterface intersedeInterface =
      new InterSedeImpl(new InterSedeProvider());

  Future<List<EnvioModel>> listarEnvios(BuildContext context,
      EnvioInterSedeModel interSedeModel, String codigo) async {
    List<EnvioModel> recorridos = await intersedeInterface.listarEnviosByCodigo(interSedeModel, codigo);

    if (recorridos.isEmpty) {
      mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
    }
    return recorridos;
  }

  void recogerdocumento(
      int id, String codigo, String paquete, bool opcion) async {
    recorridoCore.registrarRecorridoCore(codigo, id, paquete, opcion);
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }

  Future<EnvioModel> validarCodigo(
      String codigo, int id, BuildContext context) async {
    EnvioModel envio = await intersedeInterface.validarCodigo(codigo, id);
    if (envio == null) {
      mostrarAlerta(
          context, "EL codigo no pertenece al recorrido", "Codigo Incorrecto");
    }

    return envio;
  }

  void confirmacionDocumentosValidados(
      EnvioInterSedeModel sede,
      List<EnvioModel> enviosvalidados,
      BuildContext context,
      int id,
      String codigo) async {
    RecorridoModel recorrido = new RecorridoModel();
    recorrido.id = await intersedeInterface.listarEnviosValidadosInterSede(
        enviosvalidados, id, codigo);

    confirmarAlerta(
        context, "Se ha registrado correctamente la valija", "Registro",sede);
  }

  void confirmarAlerta(BuildContext context, String mensaje, String titulo,
      EnvioInterSedeModel sedeModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NuevoIntersedePage(envioInterSede: sedeModel),
                        ),
                      ))
            ],
          );
        });
  }
}
