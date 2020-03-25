import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IEntregaProvider{

  Future<List<EntregaModel>> listarEntregaporUsuario();

}