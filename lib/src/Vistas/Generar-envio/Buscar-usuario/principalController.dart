import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class PrincipalController {
  final _prefs = new PreferenciasUsuario();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();

  UsuarioInterface usuarioInterface = new UsuarioImpl(new UsuarioProvider());
  Future<List<UsuarioFrecuente>> listarusuariosfrecuentes() async {
    List<UsuarioFrecuente> usuarios = await usuarioInterface.listarUsuariosFrecuentes();
    return usuarios;
  }

  Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String text) async {
    int cantidad = obtenerCantidadMinima();
    List<UsuarioFrecuente> usuarios;
    if (text.length == 0) {
      usuarios = await usuarioInterface.listarUsuariosFrecuentes();
    } else {
      if (text.length >= cantidad) {
        usuarios = await usuarioInterface.listarUsuariosporFiltro(text);
      }else{
        usuarios=null;
      }
    }    
    return usuarios;
  }
}
