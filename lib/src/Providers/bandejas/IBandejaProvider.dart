import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IBandejaProvider{

  Future<bool> validarBandejaSobrePorCodigo(String texto);

}