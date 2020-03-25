
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/bandejas/impl/BandejaProvider.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/paquetes/impl/PaqueteProvider.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class EnvioController {

    UsuarioFrecuente usuario;
    EnvioInterface envioInterface = new EnvioImpl( new EnvioProvider(), new PaqueteProvider(), new BandejaProvider());

    void  vistacrearEnvio(UsuarioFrecuente usuarioModel,BuildContext context)  {
      this.usuario=usuarioModel;
      Navigator.of(context).pushNamed("/crear-envio");
    }


    void crearEnvio(BuildContext context, int remitenteId, int destinatarioid,String codigopaquete, String codigoUbicacion, String observacion){
        EnvioModel envioModel = new EnvioModel();
        envioModel.remitenteId = remitenteId;
        envioModel.destinatarioId = destinatarioid;
        envioModel.codigoPaquete = codigopaquete;
        envioModel.codigoUbicacion = codigoUbicacion;
        envioModel.observacion = observacion;
        envioInterface.crearEnvio(envioModel);
        mostrarAlerta(context, 'El envío se creó satisfactoriamente','Confirmación');
    }


    Future<bool> validarexistencia(String texto) async {
         bool respuesta = await envioInterface.validarCodigo(texto);
        return respuesta;
    }


    Future<bool> validarexistenciabandeja(String texto) async{
         bool respuestaBandeja = await envioInterface.validarBandejaCodigo(texto);
        return respuestaBandeja;
    }

}