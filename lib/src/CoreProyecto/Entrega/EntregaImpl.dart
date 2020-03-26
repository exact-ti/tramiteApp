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


}
