import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IPaqueteProvider{

  Future<bool> validarPaqueteSobrePorCodigo(String texto);

}