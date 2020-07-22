
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/PaqueteExterno/PaqueteExternoInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/EntregaImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recorrido/RecorridoInterface.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/impl/RecorridoProvider.dart';

class ListarTipoPersonalizadaController {

  RecorridoInterface recorridoCore = new RecorridoImpl(new RecorridoProvider());

  Future<List<TipoEntregaPersonalizadaModel>> listarTiposEntregasPersonalizadas() async {
    List<TipoEntregaPersonalizadaModel> tipoPersonalizadoList = await recorridoCore.listarTipoPersonalizada();
    return tipoPersonalizadoList;
  }

}