import 'package:tramiteapp/src/Entity/Menu.dart';

abstract class IMenuProvider{
  Future<List<Menu>> listarMenusDelUsuarioAutenticado();
}