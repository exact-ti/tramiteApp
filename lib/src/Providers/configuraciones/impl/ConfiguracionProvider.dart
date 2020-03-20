import 'package:dio/dio.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

import '../IConfiguracionProvider.dart';

class ConfiguracionProvider implements IConfiguracionProvider {
  
  Requester req = Requester();

  ConfiguracionModel configuracionmodel = new ConfiguracionModel();



  @override
  Future<List<ConfiguracionModel>> listarConfiguraciones() async{
    Response resp = await req.get('/servicio-configuracion/configuraciones');
    List<dynamic>  configuraciones = resp.data;
    List<ConfiguracionModel> listbuzon = configuracionmodel.fromJson(configuraciones);
    return listbuzon;
  }


}