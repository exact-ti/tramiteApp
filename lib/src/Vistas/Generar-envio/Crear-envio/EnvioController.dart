
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/envio/EnvioInterface.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/envios/impl/EnvioProvider.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class EnvioController {

    UsuarioFrecuente usuario;
    EnvioInterface usuarioInterface = new EnvioImpl( new EnvioProvider());

    void  vistacrearEnvio(UsuarioFrecuente usuarioModel,BuildContext context)  {
      this.usuario=usuarioModel;
      Navigator.of(context).pushNamed("/crear-envio");
    }


    void crearEnvio(int remitenteId, int destinatarioid,String codigopaquete, String codigobandeja, String observacion){
        EnvioModel envioModel = new EnvioModel();
        envioModel.remitenteId = remitenteId;
        envioModel.destinatarioId = destinatarioid;
        envioModel.codigoPaquete = codigopaquete;
        envioModel.codigoBandeja = codigobandeja;
        envioModel.observacion = observacion;




    }


    bool validarexistencia(String texto){
          if(texto=="123456789012"){
            return false;
          }else{
            return true;
          }
    }

    bool validarexistenciabandeja(String texto){
          if(texto=="123456789012"){
            return false;
          }else{
            return true;
          }
    }

}