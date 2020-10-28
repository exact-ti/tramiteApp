

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
        return await usuario.listarUsuarioFrecuenteDelUsuarioAutenticado();
  }

  @override
  Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto) async {
      return await usuario.listarUsuariosporFiltro(texto);
  }
  
}
