

import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/InterSede/InterSedeInterface.dart';
import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';

import 'package:tramiteapp/src/Providers/intersedes/impl/InterSedeProvider.dart';

class ListarEnviosController {

    InterSedeInterface intersedeInterface = new InterSedeImpl( new InterSedeProvider());
    
    Future<List<EnvioInterSedeModel>>  listarentregasInterSedeController() async {
       List<EnvioInterSedeModel> entregas =  await intersedeInterface.listarIntersedesUsuario();
        return entregas;
    }


}