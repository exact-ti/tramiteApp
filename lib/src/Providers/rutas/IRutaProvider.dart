
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';


abstract class IRutaProvider{
 
  Future<List<RutaModel>> listarMiRuta(int recorridoId);  

  Future<bool> iniciarRecorrido(int recorridoId);  
  
  Future<bool> terminarRecorrido(int recorridoId);  

}