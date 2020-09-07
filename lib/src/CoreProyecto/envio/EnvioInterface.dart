import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';

class EnvioInterface {

    Future<bool> crearEnvio(EnvioModel envioModel){}
    
    Future<bool> validarCodigo(String texto){}

    Future<bool> validarBandejaCodigo(String texto){}

    Future<List<EnvioInterSedeModel>> listarAgenciasUsuario(){}

    Future<List<EnvioModel>> listarActivos(int switched,List<int> estadosids){}

    Future<List<EstadoEnvio>> listarEstadosEnvios(){} 

    Future<List<EnvioModel>> listarEnviosUTD(){} 

    Future<List<EnvioModel>> listarEnviosHistoricos(String fechaInicio,String fechaFin,int opcion){}
    
    Future<dynamic> retirarEnvio(EnvioModel envioModel,String motivo){} 
    }


