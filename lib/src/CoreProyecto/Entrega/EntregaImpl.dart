import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/IEntregaProvider.dart';

import 'EntregaInterface.dart';


class EntregaImpl implements EntregaInterface {
  
  IEntregaProvider entrega;


  EntregaImpl(IEntregaProvider entrega) {
    this.entrega = entrega;

  }

  @override
  Future<List<EntregaModel>> listarEntregas() async {
        return await entrega.listarEntregaporUsuario();
  }

  @override
  Future<List<RecorridoModel>> listarRecorridosUsuario() async {
      return await entrega.listarRecorridoUsuario();
  }

  @override
  Future<List<EnvioModel>> listarEnviosValidacion(int recorridoId) async {
      return await entrega.listarEnviosValidacion(recorridoId) ;
  }

  @override
  Future<List<RecorridoModel>> listarRecorridosporNombre(String nombre) async {
      return  await entrega.listarRecorridoporNombre(nombre);
  }

  @override
  Future<int>  listarEnviosValidados(List<EnvioModel> envios,int id) async{
    return await entrega.listarEnviosValidados(envios,id);
  }

  @override
  Future<EnvioModel> validarCodigo(String codigo,int id) async{
    return await entrega.validarCodigoProvider(codigo,id);
  }

  @override
  Future<dynamic> listarTurnosByCodigoLote(String codigo)async {
    return await entrega.listarTurnosByCodigoLote(codigo);
  }

  @override
  Future<EnvioModel> listarValijaByCodigoLote(String codigo) async{
    return await entrega.listarValijaByCodigoLote(codigo);
  }

  @override
  Future<dynamic> registrarLoteLote(List<EnvioModel> envios, int turnoID, String codigo) async {
    return await entrega.registrarLoteLote(envios,turnoID,codigo);
  }


}
