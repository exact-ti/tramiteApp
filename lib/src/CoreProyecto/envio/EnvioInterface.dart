import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class EnvioInterface {

    void crearEnvio(EnvioModel envioModel){}
    
    Future<bool> validarCodigo(String texto){}

    Future<bool> validarBandejaCodigo(String texto){}

    Future<List<EnvioInterSedeModel>> listarAgenciasUsuario(){}

    Future<List<EnvioModel>> listarActivos(int switched){}

    }


