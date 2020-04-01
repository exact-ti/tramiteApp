import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/recorridos/IRecorridoProvider.dart';
import 'RecorridoInterface.dart';



class RecorridoImpl implements RecorridoInterface {
  
  IRecorridoProvider recorrido;


  RecorridoImpl(IRecorridoProvider recorrido) {
    this.recorrido = recorrido;

  }


  @override
  Future<List<EnvioModel>> enviosCore(String codigo, int recorridoId, bool opcion) async {
    List<EnvioModel> envios = new List();
    if(opcion){
          envios = await recorrido.enviosRecojoProvider(codigo, recorridoId) ;
    }else{
          envios = await recorrido.enviosEntregaProvider(codigo, recorridoId) ;
    }
      return envios;
  }

  @override
  void registrarRecorridoCore(String codigoArea, int recorridoId, String codigoPaquete, bool opcion) {
    if(opcion){
    recorrido.registrarRecojoProvider(codigoArea, recorridoId, codigoPaquete);
    }else{
    recorrido.registrarEntregaProvider(codigoArea, recorridoId, codigoPaquete);
    }
  }

  @override
  Future<bool> registrarEntregaPersonalizadaProvider(String dni, int recorridoId, String codigopaquete) async{
    bool respuesta = await recorrido.registrarEntregaPersonalizadaProvider(dni, recorridoId, codigopaquete);
    return respuesta;
  }



}
