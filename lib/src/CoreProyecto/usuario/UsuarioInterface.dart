import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

class UsuarioInterface {

    Future<List<UsuarioFrecuente>> listarUsuariosFrecuentes() async {}
    
    Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto) async {}

}
