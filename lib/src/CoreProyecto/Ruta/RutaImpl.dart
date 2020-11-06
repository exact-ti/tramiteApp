import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/rutas/IRutaProvider.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';

import 'RutaInterface.dart';

class RutaImpl implements RutaInterface {
  IRutaProvider ruta;

  RutaImpl(RutaProvider rutaProvider) {
    this.ruta = rutaProvider;
  }

  @override
  Future<List<RutaModel>> listarMiruta(int recorridoId) async {
    return await ruta.listarMiRuta(recorridoId);
  }

  @override
  Future<bool> opcionRecorrido(RecorridoModel recorrido) async {
    if (recorrido.indicepagina == 1) {
      return await ruta.iniciarRecorrido(recorrido.id);
    } else {
      return await ruta.terminarRecorrido(recorrido.id);
    }
  }

  @override
  Future<List<DetalleRutaModel>> listarDetalleMiRuta(bool enEntregar, String areaId, int recorridoId) async {
    if (enEntregar) {
      return await ruta.listarDetalleMiRutaEntrega(areaId,recorridoId);
    } else {
      return await ruta.listarDetalleMiRutaRecojo(areaId,recorridoId);
    }
  }
}
