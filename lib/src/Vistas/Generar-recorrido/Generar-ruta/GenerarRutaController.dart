import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaInterface.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';

class GenerarRutaController {
  RutaInterface rutaInterface = new RutaImpl(new RutaProvider());

  Future<List<RutaModel>> listarMiRuta(int recorridoId) async {
    List<RutaModel> entregas = await rutaInterface.listarMiruta(recorridoId);
    return entregas;
  }

  void opcionRecorrido(
      int recorridoId, int indicepagina, BuildContext context) async {
    bool recorrido =
        await rutaInterface.opcionRecorrido(recorridoId, indicepagina);
    if (recorrido) {
      if (indicepagina == 1) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/entrega-regular', ModalRoute.withName('/recorridos'),
            arguments: {
              'recorridoId': recorridoId,
            });
      } else {
        bool respuestatrue = await notificacion(
            context, "success", "EXACT", "Se completó el recorrido con éxito");
        if (respuestatrue) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/recorridos',
            (Route<dynamic> route) => false,
          );
        }
      }
    } else {
      notificacion(
          context, "error", "EXACT", "No se pudo terminar el recorrido");
    }
  }
}
