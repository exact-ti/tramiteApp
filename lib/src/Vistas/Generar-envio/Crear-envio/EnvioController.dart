
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class EnvioController {

    UsuarioFrecuente usuario;
    EnvioInterface envioInterface = new EnvioImpl( new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());
  final _prefs = new PreferenciasUsuario();

    void  vistacrearEnvio(UsuarioFrecuente usuarioModel,BuildContext context)  {
      this.usuario=usuarioModel;
      Navigator.of(context).pushNamed("/crear-envio");
    }


    void crearEnvio(BuildContext context, int destinatarioid,String codigopaquete, String codigoUbicacion, String observacion) async {
        EnvioModel envioModel = new EnvioModel();
        envioModel.destinatarioId = destinatarioid;
        envioModel.codigoPaquete = codigopaquete;
        envioModel.codigoUbicacion = codigoUbicacion;
        envioModel.observacion = observacion;
        bool respuesta = await  envioInterface.crearEnvio(envioModel);
        if(respuesta){
        confirmarAlerta(context, 'El envío se creó','Confirmación');
        }else{
        mostrarAlerta(context, 'No se pudo realizar el envío','Mensaje');

        }
    }


    Future<bool> validarexistencia(String texto) async {
         bool respuesta = await envioInterface.validarCodigo(texto);
        return respuesta;
    }


    Future<bool> validarexistenciabandeja(String texto) async{
         bool respuestaBandeja = await envioInterface.validarBandejaCodigo(texto);
        return respuestaBandeja;
    }
void confirmarAlerta(BuildContext context, String mensaje, String titulo) {
          Menu menuu = new Menu();
        List<dynamic> menus = json.decode(_prefs.menus);
        List<Menu> listmenu = menuu.fromPreferencs(menus);
        String inicial ="";
        for (Menu men in listmenu) {
          if (men.home) {
           inicial=men.link;
          }
        }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () =>             Navigator.of(context).pushNamedAndRemoveUntil(
                inicial, (Route<dynamic> route) => false),
              )
            ],
          );
        });
  }
}