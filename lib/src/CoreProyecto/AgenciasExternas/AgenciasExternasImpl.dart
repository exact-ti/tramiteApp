import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/IAgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'IAgenciasExternasInterface.dart';

class AgenciasExternasImpl implements IAgenciasExternasInterface {
  IAgenciaExternaProvider agenciaExterna;

  AgenciasExternasImpl(IAgenciaExternaProvider agenciaExterna) {
    this.agenciaExterna = agenciaExterna;
  }

  @override
  Future<List<EnvioInterSedeModel>> listarEnviosAgenciasUsuario() async {
    return await agenciaExterna.listarEnvioAgenciaByUsuario();
  }

  @override
  Future<dynamic> listarEnviosAgenciasByCodigo(String codigo) async {
    return await agenciaExterna.listarEnviosAgenciaByCodigo(codigo);
  }

  @override
  Future<EnvioModel> validarCodigoAgencia(String bandeja, String codigo) async {
    return await agenciaExterna.validarCodigoAgenciaProvider(bandeja, codigo);
  }

  @override
  Future<int> listarEnviosAgenciasValidados(
      List<EnvioModel> envios, String codigo) async {
    return await agenciaExterna.listarEnviosAgenciaValidadosInterSede(
        envios, codigo);
  }

  @override
  Future<bool> iniciarEntregaAgencia(EnvioInterSedeModel envio) async {
    return await agenciaExterna.iniciarEntregaExternaIntersede(envio);
  }

  @override
  Future<bool> iniciarEntregaListaAgencia(List<String> listaCodigos) async {
    return await agenciaExterna
        .iniciarListaEntregaExternaIntersede(listaCodigos);
  }

  @override
  Future<List<EnvioModel>>  listarEnviosAgenciasToCustodia() async {
    return await agenciaExterna.listarEnviosAgenciasToCustodia(obtenerUTDid());
  }

  @override
  Future custodiarPaquete(String paqueteId) async {
    return await agenciaExterna.custodiarPaquete(paqueteId,obtenerUTDid());
  }
}
