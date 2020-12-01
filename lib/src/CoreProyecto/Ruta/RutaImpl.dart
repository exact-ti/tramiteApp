import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/rutas/IRutaProvider.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';

import 'RutaInterface.dart';

class RutaImpl implements RutaInterface {
  IRutaProvider rutaProvider;

  RutaImpl(RutaProvider rutaProvider) {
    this.rutaProvider = rutaProvider;
  }

  @override
  Future<List<RutaModel>> listarMiruta(int recorridoId) async {
    return await rutaProvider.listarMiRuta(recorridoId);
  }

  @override
  Future<bool> opcionRecorrido(int recorridoId, int indicePagina) async {
    if (indicePagina == 1) {
      return await rutaProvider.iniciarRecorrido(recorridoId);
    } else {
      return await rutaProvider.terminarRecorrido(recorridoId);
    }
  }

  @override
  Future<List<DetalleRutaModel>> listarDetalleMiRuta(
      bool enEntregar, String areaId, int recorridoId) async {
    if (enEntregar) {
      return await rutaProvider.listarDetalleMiRutaEntrega(areaId, recorridoId);
    } else {
      return await rutaProvider.listarDetalleMiRutaRecojo(areaId, recorridoId);
    }
  }
}
