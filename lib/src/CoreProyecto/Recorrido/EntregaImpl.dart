import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/IRecorridoProvider.dart';
import 'RecorridoInterface.dart';

class RecorridoImpl implements RecorridoInterface {
  IRecorridoProvider recorrido;

  RecorridoImpl(IRecorridoProvider recorrido) {
    this.recorrido = recorrido;
  }

  @override
  Future<List<EnvioModel>> enviosCoreRecojo(
      String codigo, int recorridoId) async {
    return await recorrido.enviosRecojoProvider(codigo, recorridoId);
  }

  @override
  Future<dynamic> enviosCoreEntrega(
      String codigo, int recorridoId) async {
    return await recorrido.enviosEntregaProvider(codigo, recorridoId);
  }


    @override
  Future<dynamic> registrarRecorridoEntregaCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion) async {
    return await recorrido.registrarEntregaProvider(
          codigoArea, recorridoId, codigoPaquete);     
  }

  @override
  Future<dynamic> registrarRecorridoRecojoCore(String codigoArea, int recorridoId,
      String codigoPaquete, bool opcion) async {
    return await recorrido.registrarRecojoProvider(
          codigoArea, recorridoId, codigoPaquete);
  }

  @override
  Future<bool> registrarEntregaPersonalizadaProvider(
      String dni, String codigopaquete) async {
    return await recorrido.registrarEntregaPersonalizadaProvider(
        dni, codigopaquete);
  }

  @override
  Future<List<TipoEntregaPersonalizadaModel>> listarTipoPersonalizada() async  {
    return await recorrido.listarTipoPersonalizada();
  }

  @override
  Future<dynamic> registrarEntregaPersonalizadaFirmaProvider(firma, String codigopaquete) async {
    return await recorrido.registrarEntregaPersonalizadaFirmaProvider(
        firma, codigopaquete);
  }


}
