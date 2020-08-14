import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Entrega/EntregaInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaInterface.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Listar-turnos/ListarTurnosPage.dart';

class GenerarRutaController {
  RutaInterface rutaInterface = new RutaImpl(new RutaProvider());

  Future<List<RutaModel>> listarMiRuta(int recorridoId) async {
    List<RutaModel> entregas = await rutaInterface.listarMiruta(recorridoId);
    return entregas;
  }

  void opcionRecorrido(
      RecorridoModel recorridoModel, BuildContext context) async {
    bool recorrido = await rutaInterface.opcionRecorrido(recorridoModel);
    if (recorrido) {
      if (recorridoModel.indicepagina == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  EntregaRegularPage(recorridopage: recorridoModel),
            ),
            ModalRoute.withName('/recorridos'));
      } else {
        bool respuestatrue = await notificacion(
            context, "success", "EXACT", "Se completó el recorrido con éxito");
        if (respuestatrue == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ListarTurnosPage()),
              (Route<dynamic> route) => false);
        }
        if (respuestatrue) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ListarTurnosPage()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      notificacion(
          context, "error", "EXACT", "No se pudo terminar el recorrido");
    }
  }
}
