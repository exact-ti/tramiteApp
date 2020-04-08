import 'package:tramiteapp/src/ModelDto/EntregaModel.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';

class RutaInterface {

    Future<List<RutaModel>> listarMiruta(int recorridoId){}

    Future<bool> opcionRecorrido(RecorridoModel recorrido){}


    }


