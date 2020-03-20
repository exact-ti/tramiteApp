import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IUsuariosProvider{
  Future<List<UsuarioFrecuente>> listarUsuarioFrecuenteDelUsuarioAutenticado();
}