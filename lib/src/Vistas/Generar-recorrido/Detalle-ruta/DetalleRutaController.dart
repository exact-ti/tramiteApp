
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Ruta/RutaInterface.dart';
import 'package:tramiteapp/src/ModelDto/DetalleRuta.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';

class DetalleRutaController {

 RutaInterface rutaInterface = new RutaImpl(new RutaProvider());
//corregirarea
  Future<List<DetalleRutaModel>> listarDetalleRuta(int switched,int areaId,int recorrido) async {
    List<DetalleRutaModel> entregas = await rutaInterface.listarDetalleMiRuta(switched,areaId.toString(), recorrido);
    return entregas;
  }

}
