import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';

abstract class IRutaProvider {
  Future<List<RutaModel>> listarMiRuta(int recorridoId);

  Future<List<DetalleRutaModel>> listarDetalleMiRutaEntrega(
      String areaId, int recorridoId);

  Future<List<DetalleRutaModel>> listarDetalleMiRutaRecojo(
      String areaId, int recorridoId);

  Future<bool> iniciarRecorrido(int recorridoId);

  Future<bool> terminarRecorrido(int recorridoId);

  Future<dynamic> enviarNotificacionToAusencia(String paqueteId);
}
