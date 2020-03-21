import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IUsuariosProvider{

  Future<List<UsuarioFrecuente>> listarUsuarioFrecuenteDelUsuarioAutenticado();

  Future<List<UsuarioFrecuente>> listarUsuariosporFiltro(String texto);

}