import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';

abstract class IRutaProvider{
 
  Future<List<RutaModel>> listarMiRuta(int recorridoId);  
  
}