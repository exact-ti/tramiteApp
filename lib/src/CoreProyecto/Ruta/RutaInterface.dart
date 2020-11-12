import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';

abstract class RutaInterface {
  Future<List<RutaModel>> listarMiruta(int recorridoId);

  Future<bool> opcionRecorrido(int recorridoId, int indicePagina);

  Future<List<DetalleRutaModel>> listarDetalleMiRuta(
      bool enEntregar, String areaId, int recorridoId);

  Future enviarNotificacionToAusencia(String paqueteId);
}
