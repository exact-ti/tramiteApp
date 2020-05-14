import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class ListarEnviosAgenciasController {
  IAgenciasExternasInterface agenciacore =
      new AgenciasExternasImpl(new AgenciaExternaProvider());

  Future<List<EnvioInterSedeModel>> listarAgenciasExternasController() async {
    List<EnvioInterSedeModel> entregas = await agenciacore.listarEnviosAgenciasUsuario();
    return entregas;
  }

  Future<bool> onSearchButtonPressed(
      BuildContext context, EnvioInterSedeModel enviomodel) async {
    bool respuesta = await agenciacore.iniciarEntregaAgencia(enviomodel);
    return respuesta;
  }


  Future<bool>  registrarlista(
      BuildContext context, List<String> lista) async {
        bool respuesta = await agenciacore.iniciarEntregaListaAgencia(lista);

        return respuesta;


  }


}
