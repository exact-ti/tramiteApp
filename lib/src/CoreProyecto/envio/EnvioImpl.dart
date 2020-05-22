


import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
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
    bool respuestaValidar =  await paquete.validarPaqueteSobrePorCodigo(texto);
    return respuestaValidar;
  }

  @override
  Future<bool> validarBandejaCodigo(String texto) async {
    bool respuestaValidarBandeja =  await bandeja.validarBandejaSobrePorCodigo(texto);
    return respuestaValidarBandeja;
  }

  @override
  Future<List<EnvioInterSedeModel>> listarAgenciasUsuario()async {
     List<EnvioInterSedeModel> envios = await envio.listarEnvioAgenciasByUsuario();
      return envios;
  }

  @override
  Future<List<EnvioModel>> listarActivos(int switched) async{
    List<EnvioModel> envios;
      if(switched==0){
      envios = await envio.listarEnviosActivosByUsuario();
      }else{
       envios = await envio.listarRecepcionesActivas();       
      }
      return envios;
  }


}
