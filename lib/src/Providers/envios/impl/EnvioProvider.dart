import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/envios/IEnvioProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

class EnvioProvider implements IEnvioProvider {
  
  Requester req = Requester();

  ConfiguracionModel configuracionmodel = new ConfiguracionModel();


  @override
  void crearEnvioProvider(EnvioModel envio) async {
    Response resp = await req.post('/servicio-configuracion/configuraciones',envio,null);
  }


}