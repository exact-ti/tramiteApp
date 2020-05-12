import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/IEntregaProvider.dart';

import 'EntregaInterface.dart';


class EntregaImpl implements EntregaInterface {
  
  IEntregaProvider entrega;


  EntregaImpl(IEntregaProvider entrega) {
    this.entrega = entrega;

  }

  @override
  Future<List<EntregaModel>> listarEntregas() async {
     List<EntregaModel> entregas = await entrega.listarEntregaporUsuario();
        return entregas;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridosUsuario() async {
     List<RecorridoModel> recorridos = await entrega.listarRecorridoUsuario();
      return recorridos;
  }

  @override
  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId) async {
     List<EnvioModel> recorridos = await entrega.listarEnviosValidacion(recorridoId) ;
      return recorridos;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridosporNombre(String nombre) async {
     List<RecorridoModel> recorridos = await entrega.listarRecorridoporNombre(nombre);
      return recorridos;
  }

  @override
  Future<int>  listarEnviosValidados(List<EnvioModel> envios,int id) async{
    int i = await entrega.listarEnviosValidados(envios,id);
    return i;
  }

  @override
  Future<EnvioModel> validarCodigo(String codigo,int id) async{
     EnvioModel envio = await entrega.validarCodigoProvider(codigo,id);
    return envio;
  }

  @override
  Future<List<TurnoModel>> listarTurnosByCodigoLote(String codigo)async {
    List<TurnoModel> i = await entrega.listarTurnosByCodigoLote2(codigo);
    return i;
  }

  @override
  Future<EnvioModel> listarValijaByCodigoLote(String codigo) async{
    EnvioModel i = await entrega.listarValijaByCodigoLote2(codigo);
    return i;
  }

  @override
  Future<bool> registrarLoteLote(List<EnvioModel> envios, int turnoID, String codigo) async {
    bool i = await entrega.registrarLoteLote(envios,turnoID,codigo);
    return i;
  }


}
