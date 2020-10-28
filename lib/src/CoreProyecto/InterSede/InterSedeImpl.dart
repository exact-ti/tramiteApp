import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/intersedes/IInterSedeProvider.dart';
import 'InterSedeInterface.dart';


class InterSedeImpl implements InterSedeInterface {
  
  IInterSedeProvider intersede;


  InterSedeImpl(IInterSedeProvider intersede) {
    this.intersede = intersede;

  }

  @override
  Future<List<EnvioInterSedeModel>> listarIntersedesUsuario(int switched) async {
      if(switched==0){
      return await intersede.listarEnvioByUsuario();
      }else{
       return await intersede.listarRecepcionByUsuario();       
      }
  }

  @override
  Future<List<EnvioModel>> listarEnviosByCodigo(String codigo) async{
      return await intersede.listarEnviosByCodigo( codigo);
  }

  @override
  Future<List<EnvioModel>> listarRecepcionesByCodigo(String codigo) async{
      return await intersede.listarRecepcionByCodigo(codigo);
  }

  @override
  Future<EnvioModel> validarCodigo(String codigo,String codigobandeja) async{
    return await intersede.validarCodigoProvider(codigo,codigobandeja);
  }

  @override
  Future<dynamic>  listarEnviosValidadosInterSede(List<EnvioModel> envios,String codigo) async{
    return await intersede.listarEnviosValidadosInterSede(envios, codigo);
  }

  @override
  Future<bool> iniciarEntregaIntersede(int utdDestino) async{
    return await intersede.iniciarEntregaIntersede(utdDestino);
  }

  @override
  Future<dynamic> registrarRecojoIntersedeProvider(String codigo, String codigopaquete)async {
    return await intersede.registrarRecojoIntersedeProvider(codigo, codigopaquete);
  }

}
