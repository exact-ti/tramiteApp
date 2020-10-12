import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class UsuarioInterface {

    Future<List<UsuarioFrecuente>> listarUsuariosFrecuentes();
    
    Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto);

}
