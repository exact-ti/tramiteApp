
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';

class EnvioController {

    UsuarioFrecuente usuario;
    UsuarioInterface usuarioInterface = new UsuarioImpl( new UsuarioProvider());

    void  vistacrearEnvio(UsuarioFrecuente usuarioModel,BuildContext context)  {
      this.usuario=usuarioModel;
      Navigator.of(context).pushNamed("/crear-envio");
    }

}