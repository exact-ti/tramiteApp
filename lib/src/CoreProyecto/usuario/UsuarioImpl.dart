

import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/usuarios/IUsuarioProvider.dart';
import 'UsuarioInterface.dart';

class UsuarioImpl implements UsuarioInterface {
  
  IUsuariosProvider usuario;

  UsuarioImpl(IUsuariosProvider usuario) {
    this.usuario = usuario;
  }

  @override
  Future<List<UsuarioFrecuente>> listarUsuariosFrecuentes() async {
     List<UsuarioFrecuente> usuariosfrecuentes = await usuario.listarUsuarioFrecuenteDelUsuarioAutenticado();
        return usuariosfrecuentes;
  }

  @override
  Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto) async {
     List<UsuarioFrecuente> usuariosfrecuentes = await usuario.listarUsuariosporFiltro(texto);
      return usuariosfrecuentes;
  }
}
