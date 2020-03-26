
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';

class PrincipalController {
  
    UsuarioInterface usuarioInterface = new UsuarioImpl( new UsuarioProvider());
    Future<List<UsuarioFrecuente>>  listarusuariosfrecuentes() async {
       List<UsuarioFrecuente> usuarios =  await usuarioInterface.listarUsuariosFrecuentes();
        return usuarios;
    }

    Future<List<UsuarioFrecuente>>  listarUsuariosporFiltro(String text) async {
       List<UsuarioFrecuente> usuarios =  await usuarioInterface.listarUsuariosporFiltro(text);
        return usuarios;
    }


}