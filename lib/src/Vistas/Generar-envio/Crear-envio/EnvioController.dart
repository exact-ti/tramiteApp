import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';

class EnvioController {
  UsuarioFrecuente usuario;
  EnvioInterface envioInterface = new EnvioImpl(
      new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());

  void vistacrearEnvio(UsuarioFrecuente usuarioModel, BuildContext context) {
    this.usuario = usuarioModel;
    Navigator.of(context).pushNamed("/crear-envio");
  }

  void crearEnvio(BuildContext context, int destinatarioid,
      String codigopaquete, String codigoUbicacion, String observacion,UsuarioFrecuente usuarioFrecuente) async {
    EnvioModel envioModel = new EnvioModel();
    envioModel.destinatarioId = destinatarioid;
    envioModel.codigoPaquete = codigopaquete;
    envioModel.codigoUbicacion = codigoUbicacion;
    envioModel.observacion = observacion;
    bool respuesta = await envioInterface.crearEnvio(envioModel);
    if (respuesta) {
    /*   bool respuesta =
          await notificacion(context, "success", "EXACT", 'El envío se creó');
      if (respuesta) {
        Menu menuu = new Menu();
        List<dynamic> menus = json.decode(_prefs.menus);
        List<Menu> listmenu = menuu.fromPreferencs(menus);
        if(boolIfPerfil()){
        navegarHomeExact(context);
        }
        String inicial = "";
        for (Menu men in listmenu) {
          if (men.home) {
            inicial = men.link;
          }
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil(inicial, (Route<dynamic> route) => false); */
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/envio-confirmado',
          (Route<dynamic> route) => false,
          arguments: {
            'id': usuarioFrecuente.id,
            'area': usuarioFrecuente.area,
            'nombre': usuarioFrecuente.nombre,
            'sede': usuarioFrecuente.sede,
          },
        );
      /* } */
    } else {
      notificacion(context, "error", "EXACT", 'No se pudo realizar el envío');
    }
  }

  Future<bool> validarexistenciaSobre(String texto) async {
    bool respuesta = await envioInterface.validarCodigo(texto);
    return respuesta;
  }

  Future<bool> validarexistenciabandeja(String texto) async {
    bool respuestaBandeja = await envioInterface.validarBandejaCodigo(texto);
    return respuestaBandeja;
  }
}
