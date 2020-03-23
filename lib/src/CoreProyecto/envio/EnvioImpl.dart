


import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';

import 'EnvioInterface.dart';

class EnvioImpl implements EnvioInterface {
  
  IEnvioProvider envio;

  EnvioImpl(IEnvioProvider envio) {
    this.envio = envio;
  }

  @override
  void crearEnvio(EnvioModel envioModel) {
    envio.crearEnvioProvider(envioModel);
  }


}
