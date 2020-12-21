import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/AgenciasExternasImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/AgenciasExternas/IAgenciasExternasInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/NotificacionCore/NotificacionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Providers/agenciasExternas/impl/AgenciasExternasProvider.dart';
import 'package:tramiteapp/src/Providers/notificacionProvider/impl/NotificacionProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class CustodiarAgenciaController {
  IAgenciasExternasInterface agenciasCore =new AgenciasExternasImpl(new AgenciaExternaProvider());
  NotificacionInterface notificacionCore = NotificacionImpl.getInstance(new NotificacionProvider());

  void inicializarListEnviosAgencias(Function(dynamic) stateListEnvios) async {
    List<EnvioModel> listAgencias = new List();
    listAgencias = await agenciasCore.listarEnviosAgenciasToCustodia();
    stateListEnvios(listAgencias);
  }

  void custodiarConCamara(
      BuildContext context,
      Function(dynamic) stateCodigoController,
      List<EnvioModel> listEnvios,
      GlobalKey<ScaffoldState> scaffoldkey,
      Function(dynamic) stateList,
      FocusNode focusInput,
      TextEditingController _controller) async {
    String dataCamera = await getDataFromCamera(context);
    stateCodigoController(dataCamera);
    validarCodigoPaquete(dataCamera, context, listEnvios, scaffoldkey,
        stateList, focusInput, _controller);
  }

  void validarCodigoPaquete(
      dynamic value,
      BuildContext context,
      List<EnvioModel> listEnvios,
      GlobalKey<ScaffoldState> scaffoldkey,
      Function(dynamic) stateList,
      FocusNode focusInput,
      TextEditingController _controller) async {
    desenfocarInputfx(context);
    if (value != "") {
      dynamic custodiado = await agenciasCore.custodiarPaquete(value);
      if (custodiado["status"] == "success") {
        bool perteneceLista = listEnvios
            .where((paqueteExterno) => paqueteExterno.codigoPaquete == value)
            .toList()
            .isNotEmpty;
        if (perteneceLista) {
          listEnvios.removeWhere(
              (paqueteExterno) => paqueteExterno.codigoPaquete == value);
          stateList(listEnvios);
        }
        selectionText(_controller, focusInput, context);
        notifierAccion("Se ha custodiado el envío",
            StylesThemeData.PRIMARY_COLOR, scaffoldkey);
      } else {
        selectionText(_controller, focusInput, context);
        notifierAccion(
            custodiado["message"], StylesThemeData.ERROR_COLOR, scaffoldkey);
      }
    } else {
      selectionText(_controller, focusInput, context);
      notifierAccion("El código del envío es obligatorio",
          StylesThemeData.ERROR_COLOR, scaffoldkey);
    }
  }

  Future enviarNotificacion(String paqueteId) async {
    return await notificacionCore.enviarNotificacionEnAusenciaRecojo(paqueteId);
  }
}
