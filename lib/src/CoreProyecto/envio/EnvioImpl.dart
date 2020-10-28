


import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Providers/bandejas/IBandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/IPaqueteProvider.dart';

import 'EnvioInterface.dart';

class EnvioImpl implements EnvioInterface {
  
  IEnvioProvider envio;
  IPaqueteProvider paquete;
  IBandejaProvider bandeja;


  EnvioImpl(IEnvioProvider envio,IPaqueteProvider paquete,IBandejaProvider bandeja) {
    this.envio = envio;
    this.paquete =paquete;
    this.bandeja = bandeja;
  }



  @override
  Future<bool> crearEnvio(EnvioModel envioModel) {
    return envio.crearEnvioProvider(envioModel);
  }

  @override
  Future<bool> validarCodigo(String texto) async {
    return await paquete.validarPaqueteSobrePorCodigo(texto);
  }

  @override
  Future<bool> validarBandejaCodigo(String texto) async {
    return await bandeja.validarBandejaSobrePorCodigo(texto);
  }

  @override
  Future<List<EnvioInterSedeModel>> listarAgenciasUsuario()async {
      return await envio.listarEnvioAgenciasByUsuario();
  }

  @override
  Future<List<EnvioModel>> listarActivos(int switched,List<int> estadosids) async{
      if(switched==0){
      return await envio.listarEnviosActivosByUsuario(estadosids);
      }else{
       return await envio.listarRecepcionesActivas(estadosids);       
      }
  }

  @override
  Future<List<EstadoEnvio>> listarEstadosEnvios() async {
    return await envio.listarEstadosEnvios();
  }

  @override
  Future<List<EnvioModel>> listarEnviosUTD() async {
    return await envio.listarEnviosUTD();

  }

  @override
  Future<List<EnvioModel>> listarEnviosHistoricos(String fechaInicio, String fechaFin, int opcion) async {
      if(opcion==0){
      return await envio.listarEnviosHistoricosEntrada(fechaInicio,fechaFin);
      }else{
       return await envio.listarEnviosHistoricosSalida(fechaInicio,fechaFin);       
      }
  }

  @override
  Future retirarEnvio(EnvioModel envioModel,String motivo) async {
    return await envio.retirarEnvioProvider(envioModel,motivo);
  }


}
