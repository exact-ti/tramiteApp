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
  Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(int switched) async {
    List<EnvioInterSedeModel> envios;
      if(switched==0){
      envios = await intersede.listarEnvioByUsuario();
      }else{
       envios = await intersede.listarRecepcionByUsuario();       
      }
      return envios;
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo) async{
     List<EnvioModel> envios = await intersede.listarEnviosByCodigo( codigo);
      return envios; 
  }

  @override
  Future<List<EnvioModel>> listarRecepcionesByCodigo(String codigo) async{
     List<EnvioModel> envios = await intersede.listarRecepcionByCodigo(codigo);
      return envios; 
  }

  @override
  Future<EnvioModel> validarCodigo(String codigo,String codigobandeja) async{
     EnvioModel envio = await intersede.validarCodigoProvider(codigo,codigobandeja);
    return envio;
  }

  @override
  Future<int>  listarEnviosValidadosInterSede(List<EnvioModel> envios,String codigo) async{
    int i = await intersede.listarEnviosValidadosInterSede(envios, codigo);
    return i;
  }

  @override
  Future<bool> iniciarEntregaIntersede(int utdDestino) async{
    bool i = await intersede.iniciarEntregaIntersede(utdDestino);
    return i;
  }

  @override
  Future<dynamic> registrarRecojoIntersedeProvider(String codigo, String codigopaquete)async {
    dynamic i = await intersede.registrarRecojoIntersedeProvider(codigo, codigopaquete);
    return i;
  }

}
