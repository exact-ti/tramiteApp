import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/IAgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Providers/intersedes/IInterSedeProvider.dart';
import 'IAgenciasExternasInterface.dart';


class AgenciasExternasImpl implements IAgenciasExternasInterface {
  
  IAgenciaExternaProvider agenciaExterna;


  AgenciasExternasImpl(IAgenciaExternaProvider agenciaExterna) {
    this.agenciaExterna = agenciaExterna;

  }

  @override
  Future<List<EnvioInterSedeModel>> listarEnviosAgenciasUsuario() async {
    List<EnvioInterSedeModel> envios= await agenciaExterna.listarEnvioAgenciaByUsuario();
      return envios;
  }

  @override
  Future<List<EnvioModel>> listarEnviosAgenciasByCodigo(String codigo) async{
     List<EnvioModel> envios = await agenciaExterna.listarEnviosAgenciaByCodigo(codigo);
      return envios; 
  }


  @override
  Future<EnvioModel> validarCodigoAgencia(String codigo,int id) async{
     EnvioModel envio = await agenciaExterna.validarCodigoAgenciaProvider(codigo, id);
    return envio;
  }

  @override
  Future<int>  listarEnviosAgenciasValidados(List<EnvioModel> envios,String codigo) async{
    int i = await agenciaExterna.listarEnviosAgenciaValidadosInterSede(envios, codigo);
    return i;
  }

  @override
  Future<bool> iniciarEntregaAgencia(int utdDestino) async{
    bool i = await agenciaExterna.iniciarEntregaExternaIntersede(utdDestino);
    return i;
  }


}
