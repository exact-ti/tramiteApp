


import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/bandejas/IBandejaProvider.dart';
import 'package:tramiteapp/src/Providers/entregas/IEntregaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/IPaqueteProvider.dart';

import 'EntregaInterface.dart';


class EntregaImpl implements EntregaInterface {
  
  IEntregaProvider envio;



  EntregaImpl(IEntregaProvider envio) {
    this.envio = envio;

  }

  @override
  Future<List<EntregaModel>> listarEntregas() async {
     List<EntregaModel> entregas = await envio.listarEntregaporUsuario();
        return entregas;
  }


}
