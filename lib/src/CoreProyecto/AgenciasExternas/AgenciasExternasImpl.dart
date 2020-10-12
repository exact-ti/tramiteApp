import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/IAgenciasExternasProvider.dart';
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
  Future<dynamic> listarEnviosAgenciasByCodigo(String codigo) async{
     dynamic envios = await agenciaExterna.listarEnviosAgenciaByCodigo(codigo);
      return envios; 
  }


  @override
  Future<EnvioModel> validarCodigoAgencia(String bandeja,String codigo) async{
     EnvioModel envio = await agenciaExterna.validarCodigoAgenciaProvider(bandeja,codigo);
    return envio;
  }

  @override
  Future<int>  listarEnviosAgenciasValidados(List<EnvioModel> envios,String codigo) async{
    int i = await agenciaExterna.listarEnviosAgenciaValidadosInterSede(envios, codigo);
    return i;
  }

  @override
  Future<bool> iniciarEntregaAgencia(EnvioInterSedeModel envio) async{
    bool i = await agenciaExterna.iniciarEntregaExternaIntersede(envio);
    return i;
  }

  @override
  Future<bool> iniciarEntregaListaAgencia(List<String> listaCodigos) async {
    bool i = await agenciaExterna.iniciarListaEntregaExternaIntersede(listaCodigos);
    return i;
  }


}
