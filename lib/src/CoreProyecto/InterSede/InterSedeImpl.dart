import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/entregas/IEntregaProvider.dart';
import 'package:tramiteapp/src/Providers/intersedes/IInterSedeProvider.dart';
import 'InterSedeInterface.dart';


class InterSedeImpl implements InterSedeInterface {
  
  IInterSedeProvider intersede;


  InterSedeImpl(IInterSedeProvider intersede) {
    this.intersede = intersede;

  }

  @override
  Future<List<EnvioInterSedeModel>> listarIntersedesUsuario() async {
     List<EnvioInterSedeModel> envios = await intersede.listarEnvioByUsuario();
      return envios;
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(EnvioInterSedeModel envioInterSedeModel, String codigo) async{
     List<EnvioModel> envios = await intersede.listarEnviosByCodigo(envioInterSedeModel, codigo);
      return envios; 
  }

  @override
  Future<EnvioModel> validarCodigo(String codigo,int id) async{
     EnvioModel envio = await intersede.validarCodigoProvider(codigo,id);
    return envio;
  }

  @override
  Future<int>  listarEnviosValidadosInterSede(List<EnvioModel> envios,int id,String codigo) async{
    int i = await intersede.listarEnviosValidadosInterSede(envios, id, codigo);
    return i;
  }

  @override
  Future<bool> iniciarEntregaIntersede(int utdDestino) async{
    bool i = await intersede.iniciarEntregaIntersede(utdDestino);
    return i;
  }

}
